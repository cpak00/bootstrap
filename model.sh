#! /bin/bash
HOME_PATH='/workspace'
MODELS=('Qwen/Qwen2.5-7B')
MODELS_NAME=('Qwen2.5-7B')

for ((i=0; i<${#MODELS[@]}; i++))
do
    python src/hf_local.py model ${MODELS[$i]} $HOME_PATH/model/${MODELS_NAME[$i]}
done


git clone https://github.com/ramanakshay/clip $HOME_PATH/model/Clip
git clone https://github.com/cloneofsimo/vqgan-training $HOME_PATH/model/VAE
git clone https://github.com/bytedance-seed/BAGEL.git $HOME_PATH/model/Bagel-7B

hf download ByteDance-Seed/BAGEL-7B-MoT --local-dir $HOME_PATH/model/Bagel-7B/model
touch $HOME_PATH/model/Bagel-7B/__init__.py
