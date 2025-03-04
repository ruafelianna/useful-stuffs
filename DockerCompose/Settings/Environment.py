from os.path import join as join_path

from Models.Network import Network

class Environment:
    # format
    TAB = "  "
    LF = "\n"

    # network
    NetworkDomain = "silva-viridis.ru"

    class Networks:
        Dev = Network("network_sv_dev")
        Prod = Network("network_sv_prod")

    # fs
    BaseFolder = r"C:\Users\OGM-29\Desktop\maria\vm\clean\vm_x64\scripts\vm_setup"
    BaseDataFolder = join_path(BaseFolder, "data")

    GenDir = join_path(BaseFolder, "compose")
    GenExt = ".yml"

    EnvDir = "env"
    EnvExt = ".env"

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
