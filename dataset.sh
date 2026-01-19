#! /bin/bash
HOME_PATH='/workspace'
# DATASETS=('jingyaogong/minimind_dataset' 'konwoo/RedPajama-Data-1T-Sample-subset850000' 'Linly-AI/Chinese-pretraining-dataset' 'benjamin-paine/imagenet-1k-256x256')
DATASETS=('jingyaogong/minimind_dataset' 'togethercomputer/RedPajama-Data-1T' 'Linly-AI/Chinese-pretraining-dataset' 'benjamin-paine/imagenet-1k-256x256')
DATASETS_NAME=('minimind_dataset' 'RedPajama' 'Chinese-pretraining' 'Imagenet')


for ((i=0; i<${#DATASETS[@]}; i++))
do
    python src/hf_local.py dataset ${DATASETS[$i]} $HOME_PATH/dataset/${DATASETS_NAME[$i]}
done

wget -O bagel_example.zip \
  https://lf3-static.bytednsdoc.com/obj/eden-cn/nuhojubrps/bagel_example.zip
unzip bagel_example.zip -d /data

mkdir -p $HOME_PATH/dataset/mscoco
wget http://images.cocodataset.org/zips/train2017.zip -O $HOME_PATH/dataset/mscoco/train2017.zip
wget http://images.cocodataset.org/annotations/annotations_trainval2017.zip -O $HOME_PATH/dataset/mscoco/annotations_trainval2017.zip
unzip $HOME_PATH/dataset/mscoco/train2017.zip -d $HOME_PATH/dataset/mscoco
unzip $HOME_PATH/dataset/mscoco/annotations_trainval2017.zip -d $HOME_PATH/dataset/mscoco
