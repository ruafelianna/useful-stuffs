from ComposeModels.ComposeFile import ComposeFile
from Models.Volume import Volume
from Settings.Environment import Environment as env

pgadmin = ComposeFile(
    container_name = "pgadmin",
    host_prefix = "pgadmin",
    image_name = "dpage/pgadmin4",
    image_version = "9.1.0",
    networks = (
        env.Networks.Dev,
        env.Networks.Prod,
    ),
    # volumes = (
    #     Volume("data", "/var/lib/pgadmin/"),
    # ),
    env_vars = set((
        f"PGADMIN_DEFAULT_EMAIL=",
        f"PGADMIN_DEFAULT_PASSWORD=",
    )),
)
