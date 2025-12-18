#! /bin/bash
# set -xeo pipefail

git config --global user.email "cymcpak00@gmail.com"
git config --global user.name "Chen Yiming"

MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
MINICONDA_DIR="${HOME}/miniconda"

install_miniconda() {
    echo "⬇️ Installing Miniconda (Linux)..."
    tmp_dir="$(mktemp -d)"
    installer_path="${tmp_dir}/miniconda.sh"
    curl -fsSL "${MINICONDA_URL}" -o "${installer_path}"
    bash "${installer_path}" -b -p "${MINICONDA_DIR}"
    local conda_bin="${MINICONDA_DIR}/bin/conda"

    rm -rf "${tmp_dir}"
}

ensure_miniconda() {
    local conda_sh="${MINICONDA_DIR}/etc/profile.d/conda.sh"
    if [ -d "${MINICONDA_DIR}" ]; then
        if ! ( source "${conda_sh}" >/dev/null 2>&1 && conda activate base >/dev/null 2>&1 ); then
            echo "⚠️ Failed to activate existing Miniconda, reinstalling..."
            rm -rf "${MINICONDA_DIR}"
            install_miniconda
        fi
    else
        install_miniconda
    fi
    export PATH="${MINICONDA_DIR}/bin:${PATH}"
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
    conda init --all
}

ensure_miniconda

ENV_NAME="te"
PYTHON_VERSION="3.12"

# CONDA_BASE=$(conda info --base)
# source "${CONDA_BASE}/etc/profile.d/conda.sh"
conda activate base

# --- Create the environment if it doesn’t exist ---
if ! conda info --envs | grep -q "$ENV_NAME"; then
    echo "🧩 Creating new conda environment: $ENV_NAME"
    conda create -y -n "$ENV_NAME" python="$PYTHON_VERSION"
else
    echo "✅ Conda environment '$ENV_NAME' already exists."
fi

# --- Activate the environment ---
# Note: we must source conda.sh to use 'conda activate' in a script.
conda activate "$ENV_NAME"

echo "✅ Activated environment: $ENV_NAME"
echo "Python version: $(python --version)"

cd "$HOME"

conda install -y -c nvidia -c conda-forge pytorch=2.9 transformers=4.57 cuda=12.9.1 cuda-toolkit=12.9

export CUDA_PATH=/usr/local/cuda
export PATH=$CUDA_PATH/bin:$PATH
pip install --no-build-isolation transformer_engine[pytorch]
