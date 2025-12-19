#! /bin/bash
HOME_PATH='/workspace'
MODELS=('Qwen/Qwen3-4B')
MODELS_NAME=('Qwen3-4B')

for ((i=0; i<${#MODELS[@]}; i++))
do
    python src/hf_local.py model ${MODELS[$i]} $HOME_PATH/model/${MODELS_NAME[$i]}
done


git clone https://github.com/ramanakshay/clip $HOME_PATH/model/Clip
git clone https://github.com/cloneofsimo/vqgan-training $HOME_PATH/model/VAE