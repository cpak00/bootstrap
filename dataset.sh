#! /bin/bash
HOME_PATH='/workspace'
DATASETS=('konwoo/RedPajama-Data-1T-Sample-subset850000' 'Linly-AI/Chinese-pretraining-dataset')
DATASETS_NAME=('RedPajama' 'Chinese-pretraining')


for ((i=0; i<${#DATASETS[@]}; i++))
do
    python src/hf_local.py dataset ${DATASETS[$i]} $HOME_PATH/dataset/${DATASETS_NAME[$i]}
done