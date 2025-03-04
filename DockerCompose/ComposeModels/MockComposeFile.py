from __future__ import annotations

from ComposeModels.ComposeFile import ComposeFile
from Models.Network import Network

class MockComposeFile(ComposeFile):
    def __init__(
        self,
        container_name : str,
        host_prefix : str,
        networks : tuple[Network] = (),
    ):
        super().__init__(
            container_name = container_name,
            host_prefix = host_prefix,
            image_name = None,
            image_version = None,
            networks = networks,
        )
