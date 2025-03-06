from ComposeModels.ComposeFile import ComposeFile
from Enums.StandardPorts import StandardPorts
from Models.Port import Port
from Models.Volume import Volume
from Settings.Environment import Environment as env

web_dev = ComposeFile(
    container_name = "web_dev",
    host_prefix = "dev.web",
    image_name = "nginx",
    image_version = "1.27.4",
    networks = (
        env.Networks.Dev,
    ),
    volumes = (
        Volume(env.Nginx.ConfFile, "/etc/nginx/nginx.conf"),
        Volume(env.Nginx.ConfDir, "/etc/nginx/conf.d/"),
        Volume(env.Nginx.StreamConfDir, "/etc/nginx/stream.conf.d/"),
    ),
    ports = (
        Port(StandardPorts.Nginx, 80),
    ),
)
