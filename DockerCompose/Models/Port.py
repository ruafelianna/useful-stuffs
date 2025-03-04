class Port:
    def __init__(self, internal : int, external : int | None = None):
        self.external = external
        self.internal = internal
