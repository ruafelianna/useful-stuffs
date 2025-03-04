from os.path import join as path_join

from Settings.Environment import Environment as env

class Volume:
    def __init__(self, host_path : str, container_path : str):
        self.container_path = container_path
        self.host_path = host_path

    def full_host_path(self, container_name: str):
        return path_join(env.BaseDataFolder, container_name, self.host_path)
