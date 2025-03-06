class EnvVar:
    def __init__(self, name : str, default_value : str):
        self.name = name
        self.default_value = default_value

    def get_full_var(self):
        return f"{self.name}={self.default_value}"
