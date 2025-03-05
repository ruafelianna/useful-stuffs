from os import makedirs, removedirs
from os.path import join as join_path, exists as dir_exists

from ComposeModels.ComposeFile import ComposeFile
from Settings.Environment import Environment as env
from Enums.StandardPorts import StandardPorts
from Settings.Settings import composer_files, servers

hosts = set()

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

def generate_nginx_conf(server : ComposeFile):
    path = join_path(env.BaseDataFolder, server.container_name, env.Nginx.ConfFile)
    lines = (
        
    )

    with create_file(path) as fd:
        fd.write(env.LF.join(lines))

def generate_nginx_conf_d_file(server : ComposeFile, dep : ComposeFile):
    path = join_path(env.BaseDataFolder, server.container_name, env.Nginx.ConfDir, f"{dep.container_name}{env.Nginx.ConfExt}")
    lines = (
        "server {",
        f"{env.TAB}listen {StandardPorts.Nginx};",
        f"{env.TAB}server_name {dep.get_hostname()};",
        "}",
        env.LF,
    )

    with create_file(path) as fd:
        fd.write(env.LF.join(lines))

if dir_exists(env.GenDir):
    removedirs(env.GenDir)

makedirs(env.GenDir)

if dir_exists(env.EnvDir):
    removedirs(env.EnvDir)

makedirs(env.EnvDir)

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
            generate_nginx_conf(server)
            for dep in server.dependencies:
                generate_nginx_conf_d_file(server, dep)

hosts = env.LF.join(sorted(hosts))

with create_file(join_path(env.GenDir, env.HostsFile)) as fd:
    fd.write(hosts + env.LF)
