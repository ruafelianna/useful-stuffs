from __future__ import annotations

from Models.EnvFile import EnvFile
from Models.Network import Network
from Models.Port import Port
from Models.Volume import Volume
from Settings.Environment import Environment as env

class ComposeFile:
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
        self.container_name = container_name
        self.host_prefix = host_prefix
        self.image_name = image_name
        self.image_version = image_version
        self.networks = networks
        self.volumes = volumes
        self.ports = ports
        self.command = command
        self.env_vars = env_vars
        self.env_files : set[EnvFile] = set()
        self.dependencies : set[ComposeFile] = set()

    # properties

    def get_hostname(self):
        return f"{self.host_prefix}.{env.NetworkDomain}"

    def get_image(self):
        return f"{self.image_name}:{self.image_version}"

    def get_volume(self, volume : Volume) -> str:
        return f"{volume.get_full_host_path(self.container_name)}:{volume.container_path}"

    # docker compose file generation

    def generate_compose_file(self) -> str:
        self.env_files.add(EnvFile(self.container_name))
        return self._concat_fields((
            self._generate_section_services(),
            self._generate_section_networks(),
        ))

    # fields generation

    def _generate_container_name(self) -> str:
        return f"container_name: {self.container_name}"

    def _generate_hostname(self) -> str:
        return f"hostname: {self.get_hostname()}"

    def _generate_image(self) -> str:
        return f"image: {self.get_image()}"

    def _generate_restart(self) -> str:
        return "restart: always"

    def _generate_command(self) -> str:
        return f"command: {self.command}" if self._check_not_empty(self.command) else None

    def _generate_build(self) -> str:
        return None

    def _generate_networks(self) -> str:
        return self._generate_list("networks", self.networks, lambda x: x.name, 3)

    def _generate_volumes(self) -> str:
        def func(volume : Volume) -> str:
            return self.get_volume(volume)
        return self._generate_list("volumes", self.volumes, func, 3)

    def _generate_env_file(self) -> str:
        return self._generate_list("env_file", self.env_files, EnvFile.get_full_path, 3)

    def _generate_depends_on(self) -> str:
        def func(container : ComposeFile) -> str:
            return container.container_name
        return self._generate_list("depends_on", self.dependencies, func, 3)
    
    # sections generation

    def _generate_section_services(self) -> str:
        fields = (
            self._generate_container_name(),
            self._generate_hostname(),
            self._generate_image(),
            self._generate_build(),
            self._generate_networks(),
            self._generate_restart(),
            self._generate_volumes(),
            self._generate_env_file(),
            self._generate_depends_on(),
            self._generate_command(),
        )
        fields = self._concat_fields(fields, 2)
        return f"services:{env.LF}{env.TAB}{self.container_name}:{env.LF}{fields}"
    
    def _generate_section_networks(self) -> str:
        networks = [f"{network.name}:{env.LF}{env.TAB}{env.TAB}external: true" for network in self.networks]
        networks = self._concat_fields(networks, 1)
        return f"networks:{env.LF}{networks}" \
            if self._check_not_empty(self.networks) else None
    
    # utils

    def _generate_list(self, caterogy: str, data: tuple, func: function[object, str], tabs: int) -> str:
        data = [f"- {func(obj)}" for obj in data]
        return f"{caterogy}:{env.LF}{self._concat_fields(data, tabs)}" \
            if self._check_not_empty(data) else None

    def _check_not_empty(self, data: tuple) -> bool:
        return data is not None and len(data) > 0

    def _concat_fields(self, fields: tuple[str], tabs: int = 0) -> str:
        fields = filter(lambda x: x is not None, fields)
        fields = [f"{env.TAB * tabs}{field}" for field in fields]
        return env.LF.join(fields)
