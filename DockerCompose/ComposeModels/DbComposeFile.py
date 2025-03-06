from ComposeModels.ComposeFile import ComposeFile
from Models.Network import Network
from Models.Port import Port
from Models.Volume import Volume
from Settings.Environment import Environment as env

class DbComposeFile(ComposeFile):
    def __init__(
        self,
        container_name : str,
        host_prefix : str,
        image_name : str,
        image_version : str,
        networks : tuple[Network] = (),
        volumes : tuple[Volume] = (),
        ports : tuple[Port] = (),
        command : str = None,
        env_vars: set[str] = (),
    ):
        super().__init__(
            container_name = container_name,
            host_prefix = host_prefix,
            image_name = image_name,
            image_version = image_version,
            networks = networks,
            volumes = volumes,
            ports = ports,
            command = command,
            env_vars = env_vars
        )