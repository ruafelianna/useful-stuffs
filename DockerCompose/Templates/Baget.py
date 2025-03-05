from ComposeModels.ComposeFile import ComposeFile
from ComposeModels.PostgresComposeFile import PostgresComposeFile
from Enums.StandardPorts import StandardPorts
from Models.EnvFile import EnvFile
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
    env_vars = set((
        f"ApiKey={env.BagetApiKey}",
        "Storage__Type=FileSystem",
        "Database__Type=PostgreSql",
        "Search__Type=Database",
    )),
)

baget_db = PostgresComposeFile(baget, env.Pg.PortDelta_Baget)

baget.env_vars.add(f"Storage__Path={pkgs.get_full_host_path(baget.container_name)}")
baget.env_vars.add(f"Database__ConnectionString=UserID=${{POSTGRES_USER}};Password=${{POSTGRES_PASSWORD}};Host={baget_db.container_name};Port={StandardPorts.Postgres};Database=${{POSTGRES_DB}};")
baget.env_files.add(EnvFile(baget_db.container_name))
baget.dependencies.add(baget_db)
