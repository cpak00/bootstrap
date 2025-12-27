#! /bin/bash
HOME_PATH='/workspace'
DATASETS=('konwoo/RedPajama-Data-1T-Sample-subset850000' 'Linly-AI/Chinese-pretraining-dataset')
DATASETS_NAME=('RedPajama' 'Chinese-pretraining')


for ((i=0; i<${#DATASETS[@]}; i++))
do
    python src/hf_local.py dataset ${DATASETS[$i]} $HOME_PATH/dataset/${DATASETS_NAME[$i]}
done

mkdir -p $HOME_PATH/dataset/mscoco
wget http://images.cocodataset.org/zips/train2017.zip -O $HOME_PATH/dataset/mscoco/train2017.zip
wget http://images.cocodataset.org/annotations/annotations_trainval2017.zip -O $HOME_PATH/dataset/mscoco/annotations_trainval2017.zip
unzip $HOME_PATH/dataset/mscoco/train2017.zip -d $HOME_PATH/dataset/mscoco
unzip $HOME_PATH/dataset/mscoco/annotations_trainval2017.zip -d $HOME_PATH/dataset/mscoco
