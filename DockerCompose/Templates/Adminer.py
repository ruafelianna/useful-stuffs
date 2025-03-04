from ComposeModels.ComposeFile import ComposeFile
from Settings.Environment import Environment as env

adminer = ComposeFile(
    container_name = "adminer",
    host_prefix = "adminer",
    image_name = "adminer",
    image_version = "4",
    networks = (
        env.Networks.Dev,
        env.Networks.Prod,
    ),
)
