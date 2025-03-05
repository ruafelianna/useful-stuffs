from ComposeModels.MockComposeFile import MockComposeFile
from ComposeModels.PostgresComposeFile import PostgresComposeFile
from Models.EnvFile import EnvFile
from Settings.Environment import Environment as env

sv_devconf = MockComposeFile(
    container_name = "sv_devconf",
    host_prefix = "devconf",
    networks = (
        env.Networks.Dev,
        env.Networks.Prod,
    ),
)

sv_devconf_db = PostgresComposeFile(sv_devconf, env.Pg.PortDelta_SvDevConf)

sv_devconf.env_files.add(EnvFile(sv_devconf_db.container_name))
sv_devconf.dependencies.add(sv_devconf_db)
