from os import makedirs, removedirs
from os.path import join as join_path, exists as dir_exists

from ComposeModels.ComposeFile import ComposeFile
from Models.Network import Network
from Settings.Environment import Environment as env
from Settings.Settings import composer_files, servers

if dir_exists(env.GenDir):
    removedirs(env.GenDir)

makedirs(env.GenDir)

for file in composer_files:
    result = file.generate_compose_file()

    if result[len(result) - 1] is not env.LF:
        result = result + env.LF

    with open(join_path(env.GenDir, f"{file.container_name}{env.GenExt}"), "w") as fd:
        fd.write(result)
