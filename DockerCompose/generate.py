from os import makedirs, removedirs
from os.path import join as join_path, exists as dir_exists

from ComposeModels.ComposeFile import ComposeFile
from ComposeModels.DbComposeFile import DbComposeFile
from ComposeModels.PostgresComposeFile import PostgresComposeFile
from Settings.Environment import Environment as env
from Enums.StandardPorts import StandardPorts
from Models.Port import Port
from Settings.Settings import composer_files, servers

hosts = set()
env_dir = join_path(env.GenDir, env.EnvDir)

def create_file(path : str):
    return open(path, "w")

def generate_compose_files(files : tuple[ComposeFile] | list[ComposeFile]) -> None:
    for file in files:
        hosts.add(f"127.0.0.1 {file.host_prefix}.{env.NetworkDomain}")

        result = file.generate_compose_file()

        if result[len(result) - 1] is not env.LF:
            result = result + env.LF

        path = join_path(env.GenDir, f"{file.container_name}{env.GenExt}")

        with create_file(path) as fd:
            fd.write(result)

        path = join_path(env_dir, f"{file.container_name}{env.EnvExt}")

        result = env.LF.join(file.env_vars)

        with create_file(path) as fd:
            fd.write(result)

def generate_nginx_conf(server : ComposeFile):
    path = join_path(env.BaseDataFolder, server.container_name)

    if not dir_exists(path):
        makedirs(path)

    path = join_path(path, env.Nginx.ConfFile)
    lines = (
        "",
        "user nginx;",
        "worker_processes auto;",
        "error_log /var/log/nginx/error.log notice;",
        "pid /var/run/nginx.pid;",
        "events {",
        f"{env.TAB}worker_connections 1024;",
        "}",
        "http {",
        f"{env.TAB}include /etc/nginx/mime.types;",
        f"{env.TAB}default_type aplication/octet-stream;",
        f"{env.TAB}log_format main '$remote_addr - $remote_user [$time_local] \"$request\" $status $body_bytes_sent \"$http_referer\" \"$http_user_agent\" \"$http_x_forwarded_for\"';",
        f"{env.TAB}access_log /var/log/nginx/access.log main;",
        f"{env.TAB}sendfile on;",
        f"{env.TAB}#tcp_nopush on;",
        f"{env.TAB}keepalive_timeout 65;",
        f"{env.TAB}#gzip on;",
        f"{env.TAB}include /etc/nginx/conf.d/*.conf;",
        "}",
        "stream {",
        f"{env.TAB}include /etc/nginx/stream.conf.d/*.conf;",
        "}",
    )

    with create_file(path) as fd:
        fd.write(env.LF.join(lines))

def generate_nginx_conf_d_file(server : ComposeFile, dep : ComposeFile):
    port = dep.ports[0] if len(dep.ports) > 0 else Port(80)

    if isinstance(dep, DbComposeFile):
        path = join_path(env.BaseDataFolder, server.container_name, env.Nginx.StreamConfDir)

        if isinstance(dep, PostgresComposeFile):
            lfport = StandardPorts.Postgres
        else:
            raise NotImplementedError()
        if port.internal != lfport:
            raise ValueError()
        lines = (
            "server {",
            f"{env.TAB}listen {port.external};",
            f"{env.TAB}proxy_pass {dep.container_name}:{port.external};",
            "}",
        )
    else:
        path = join_path(env.BaseDataFolder, server.container_name, env.Nginx.ConfDir)

        lines = (
            "server {",
            f"{env.TAB}listen {StandardPorts.Nginx};",
            f"{env.TAB}server_name {dep.get_hostname()};",
            f"{env.TAB}location / {{",
            f"{env.TAB}{env.TAB}proxy_pass http://{dep.container_name}:{port.internal};",
            f"{env.TAB}{env.TAB}proxy_set_header Host $host;",
            f"{env.TAB}{env.TAB}proxy_set_header X-Real-IP $remote_addr;",
            f"{env.TAB}{env.TAB}proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;",
            f"{env.TAB}{env.TAB}proxy_set_header X-Forwarded-Proto $scheme;",
            f"{env.TAB}}}",
            "}",
            env.LF,
        )

    if not dir_exists(path):
        makedirs(path)

    path = join_path(path, f"{dep.get_hostname()}{env.Nginx.ConfExt}")

    with create_file(path) as fd:
        fd.write(env.LF.join(lines))

if dir_exists(env.GenDir):
    removedirs(env.GenDir)

makedirs(env.GenDir)
makedirs(env_dir)

generate_compose_files(composer_files)

for file in composer_files:
    for (network, serverList) in servers.items():
        if network in file.networks:
            for server in serverList:
                server.dependencies.add(file)

generate_compose_files(sum(servers.values(), ()))

for (network, serverList) in servers.items():
    for server in serverList:
        if server.image_name == "nginx":
            containers = " ".join((f"-f {d.container_name}{env.GenExt}" for d in server.dependencies))
            execute_cmd = f"sudo docker compose {containers} -f {server.container_name}{env.GenExt} up"
            path = join_path(env.GenDir, f"{env.ScriptPrefix}{server.container_name}{env.ScriptExt}")

            with create_file(path) as fd:
                fd.write(execute_cmd + env.LF)

            generate_nginx_conf(server)

            for dep in server.dependencies:
                generate_nginx_conf_d_file(server, dep)

hosts = env.LF.join(sorted(hosts))

with create_file(join_path(env.GenDir, env.HostsFile)) as fd:
    fd.write(hosts + env.LF)