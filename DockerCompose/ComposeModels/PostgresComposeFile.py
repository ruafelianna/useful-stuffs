from ComposeModels.ComposeFile import ComposeFile
from Enums.StandardPorts import StandardPorts
from Models.Port import Port
from Models.Volume import Volume
from Settings.Environment import Environment as env

class PostgresComposeFile(ComposeFile):
    def __init__(
        self,
        parent_container : ComposeFile,
        port_delta : int = 0
    ):
        super().__init__(
            container_name = f"{parent_container.container_name}_db",
            host_prefix = f"pg.{parent_container.host_prefix}",
            image_name = env.Pg.Image,
            image_version = env.Pg.Version,
            networks = parent_container.networks,
            volumes = (
                Volume("pgdata", env.Pg.Data),
            ),
            ports = (
                Port(StandardPorts.Postgres, StandardPorts.Postgres + port_delta),
            ),
            envvars = (
                f"POSTGRES_DB={parent_container.container_name}",
                f"POSTGRES_USER={parent_container.container_name}",
                f"POSTGRES_DB={parent_container.container_name}",
            ),
        )
