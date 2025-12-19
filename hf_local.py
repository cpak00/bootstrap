from huggingface_hub import snapshot_download, configure_http_backend

import ssl
import requests
import sys

def backend():
    session = requests.Session()
    session.verify = False
    return session

configure_http_backend(backend_factory=backend)

repo_type = sys.argv[1]
repo_id = sys.argv[2]
local_dir = sys.argv[3]

with backend():
    snapshot_download(
        repo_id = repo_id,
        repo_type = repo_type,
        local_dir = local_dir,
        local_dir_use_symlinks = False
    )