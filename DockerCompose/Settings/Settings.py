from ComposeModels.ComposeFile import ComposeFile
from Models.Network import Network
from Settings.Environment import Environment as env
from Templates.Adminer import adminer
from Templates.Baget import baget, baget_db
from Templates.Gitea import gitea, gitea_db
from Templates.PgAdmin import pgadmin
from Templates.PythonFlask import python_flask
from Templates.SvDevConf import sv_devconf, sv_devconf_db
from Templates.WebDev import web_dev

composer_files = (
    adminer,
    baget,
    baget_db,
    gitea,
    gitea_db,
    pgadmin,
    python_flask,
    #sv_devconf,
    sv_devconf_db,
)

servers : dict[Network, tuple[ComposeFile]] = {
    env.Networks.Dev: (
        web_dev,
    ),
    env.Networks.Prod: (

    ),
}
