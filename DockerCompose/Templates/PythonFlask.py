from ComposeModels.PythonComposeFile import PythonComposeFile
from Enums.StandardPorts import StandardPorts
from Models.Volume import Volume
from Settings.Environment import Environment as env

_baseVolume = Volume("app", "/usr/src/app/")

python_flask = PythonComposeFile(
    container_name = "python_flask",
    host_prefix = "flask.python",
    image_name = "python",
    image_version = "3.13",
    base_volume = _baseVolume,
    networks = (
        env.Networks.Dev,
        env.Networks.Prod,
    ),
    volumes = (
        _baseVolume,
    ),
    command = f"flask run --host=0.0.0.0 --port={StandardPorts.Flask}",
    pip_flags = (
        "--proxy http://10.2.0.1:2127",
    ),
)
