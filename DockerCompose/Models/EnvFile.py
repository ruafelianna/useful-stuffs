from os.path import join as path_join

from Settings.Environment import Environment as env

class EnvFile:
    def __init__(self, name: str):
        self.name = name

    def get_full_path(self):
        return path_join(env.EnvDir, f"{self.name}{env.EnvExt}")
