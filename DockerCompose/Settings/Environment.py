from os.path import join as join_path

from Models.Network import Network

class Environment:
    # format
    TAB = "  "
    LF = "\n"

    # network
    NetworkDomain = "some-domain.local"

    class Networks:
        Dev = Network("network_sv_dev")
        Prod = Network("network_sv_prod")

    # fs
    BaseFolder = r"/some/path"
    BaseDataFolder = join_path(BaseFolder, "data")

    GenDir = join_path(BaseFolder, "compose")
    GenExt = ".yml"

    EnvDir = "env"
    EnvExt = ".env"

    HostsFile = "hosts.txt"

    ScriptPrefix = "run_"
    ScriptExt = ".sh"

    # nginx
    class Nginx:
        ConfExt = ".conf"
        ConfFile = f"nginx{ConfExt}"
        ConfDir = "nginx_conf_d"
        StreamConfDir = "nginx_stream_conf_d"

    # postgres
    class Pg:
        Image = "postgres"
        Version = "17.4"
        Data = "/var/lib/postgresql/data/"

        PortDelta_SvDevConf = 0
        PortDelta_Baget = 1
        PortDelta_Gitea = 2

    # other
    BagetApiKey = "API_KEY"
