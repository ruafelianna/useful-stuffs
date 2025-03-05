from ComposeModels.ComposeFile import ComposeFile
from ComposeModels.PostgresComposeFile import PostgresComposeFile
from Models.EnvFile import EnvFile
from Models.Volume import Volume
from Settings.Environment import Environment as env

gitea = ComposeFile(
    container_name = "gitea",
    host_prefix = "gitea",
    image_name = "gitea/gitea",
    image_version = "1.23.4",
    networks = (
        env.Networks.Dev,
    ),
    volumes = (
        Volume("data", "/var/lib/gitea/"),
        Volume("conf", "/etc/gitea/"),
    ),
    env_vars = set((
        "GITEA__database__DB_TYPE=postgres",
        "GITEA__database__NAME=${POSTGRES_DB}",
        "GITEA__database__USER=${POSTGRES_USER}",
        "GITEA__database__PASSWD==${POSTGRES_PASSWORD}",
    )),
)

gitea_db = PostgresComposeFile(gitea, env.Pg.PortDelta_Gitea)

gitea.env_vars.add(f"GITEA__database__HOST={gitea_db.container_name}")
gitea.env_files.add(EnvFile(gitea_db.container_name))
gitea.dependencies.add(gitea_db)
