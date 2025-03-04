from ComposeModels.ComposeFile import ComposeFile
from ComposeModels.PostgresComposeFile import PostgresComposeFile
from Enums.StandardPorts import StandardPorts
from Models.Volume import Volume
from Settings.Environment import Environment as env

pkgs = Volume("packages", "/var/baget/packages/")

baget = ComposeFile(
    container_name = "baget",
    host_prefix = "baget",
    image_name = "loicsharma/baget",
    image_version = "0.4.0-preview2",
    networks = (
        env.Networks.Dev,
    ),
    volumes = (
        pkgs,
    ),
    envvars = (
        f"ApiKey={env.BagetApiKey}",
        "Storage__Type=FileSystem",
        "Database__Type=PostgreSql",
        "Search__Type=Database",
    ),
)

baget_db = PostgresComposeFile(baget, env.Pg.PortDelta_Baget)

baget.add_env(baget_db)
baget.add_dep(baget_db)
baget.envvars.add(f"Storage__Path={pkgs.full_host_path(baget.container_name)}")
baget.envvars.add(f"Database__ConnectionString=UserID=${{POSTGRES_USER}};Password=${{POSTGRES_PASSWORD}};Host={baget_db.container_name};Port={StandardPorts.Postgres};Database=${{POSTGRES_DB}};")
