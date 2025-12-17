#! /bin/bash
set -xeo pipefail

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
    if [ -x "${conda_bin}" ]; then
        ${conda_bin} tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
        ${conda_bin} tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
    fi
    export PATH="${MINICONDA_DIR}/bin:${PATH}"
}

ensure_miniconda

ENV_NAME="triton"
PYTHON_VERSION="3.11"

CONDA_BASE=$(conda info --base)
source "${CONDA_BASE}/etc/profile.d/conda.sh"
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
mkdir -p repos
cd repos
if [ ! -d "ascend-bench" ]; then
    git clone --recurse-submodules git@github.com:mdrumond/ascend-bench.git
else
    echo "✅ Repository 'ascend-bench' already exists, skipping clone."
fi
cd ascend-bench
python -m pip install -r requirements.txt
python -m pip install -e .


cd third-party/Triton-distributed

git submodule deinit --all -f # deinit previous submodules
rm -rf 3rdparty/triton # remove previous triton
git submodule update --init --recursive

# conda install -y -c nvidia -c conda-forge cuda=12.9.1 cuda-toolkit=12.9 cuda-toolkit-dev=12.9
conda install -y -c conda-forge gxx_linux-64 ccache
conda install -y -c conda-forge "libstdcxx-ng>=13" "libgcc-ng>=13" "protobuf=3.20"
pip install torch==2.8
pip install cuda-python==12.8 # need to align with your nvcc version
pip install --upgrade "protobuf==3.20.*"
pip install --upgrade deepspeed
pip install setuptools==68.2.2 cython wheel pybind11 meson-python meson ninja flashinfer-python termcolor accelerate tg4perfetto
pip install flash-attn --no-build-isolation
pip uninstall -y triton
pip uninstall -y triton_dist # remove previous triton-dist

  

export USE_TRITON_DISTRIBUTED_AOT=0
echo 'numpy<2' > /tmp/pip_install_constraint.txt
MAX_JOBS=8 pip install -c /tmp/pip_install_constraint.txt -e python[build,tests,tutorials] --verbose --no-build-isolation --use-pep517
