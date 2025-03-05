from os.path import join as path_join

from ComposeModels.ComposeFile import ComposeFile
from Models.Network import Network
from Models.Port import Port
from Models.Volume import Volume
from Settings.Environment import Environment as env

class PythonComposeFile(ComposeFile):
    def __init__(
        self,
        container_name : str,
        host_prefix : str,
        image_name : str,
        image_version : str,
        base_volume : Volume,
        networks : tuple[Network] = (),
        volumes : tuple[Volume] = (),
        ports : tuple[Port] = (),
        command : str = None,
        env_vars: set[str] = (),
        pip_flags : tuple[str] = (),
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
        self.base_volume = base_volume
        self.pip_flags = pip_flags

    def _generate_image(self):
        return None

    def _generate_build(self):
        fields3 = (
            f"context: {self.base_volume.host_path}",
            "dockerfile_inline: |",
        )
        fields4 = (
            f"FROM {self.image_name}:{self.image_version}",
            f"WORKDIR {self.base_volume.container_path}",
            "COPY ./requirements.txt ./",
            f"RUN pip install --no-cache-dir -r requirements.txt {self.pip_flags}",
        )
        return f"build:{env.LF}{self._concat_fields(fields3, 3)}{env.LF}{self._concat_fields(fields4, 4)}"
