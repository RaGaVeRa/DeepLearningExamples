
# Script to convert Tacotron2 checkpoint into torchscript for to be deployed in
# Nvidia Triton inference server
# Also creates config.pbtxt for the model
#Example: bash  scripts/deploy_tacotron2.sh output_tacotron2_transferlearn_sgk/checkpoint_Tacotron2_6475.pt sg-kan-tacotron2 test_deploy

set -e

CHECKPOINT_FILE=$1
INFER_MODEL_NAME=$2
MODELS_ROOT=$3

usage()
{
	echo $0 "<tacotron2_pytorch_checkpoint> <infer_model_name> <models_root>"
}

if [[ ${CHECKPOINT_FILE}zz == zz ]]
then
	usage
	exit 1
fi

if [[ ${INFER_MODEL_NAME}zz == zz ]]
then
	usage
	exit 1
fi

if [[ ${MODELS_ROOT}zz == zz ]]
then
	usage
	exit 1
fi

mkdir -p ${MODELS_ROOT}

OUTPUT_DIR=${MODELS_ROOT}/${INFER_MODEL_NAME}

if [[ -f ${OUTPUT_DIR}/1/model.pt ]]
then
	echo "${OUTPUT_DIR}/model.pt already exists"
	exit 2
fi

mkdir -p ${OUTPUT_DIR}/1/

python exports/export_tacotron2_ts.py --tacotron2 ${CHECKPOINT_FILE}  --output ${OUTPUT_DIR}/1/model.pt

python exports/export_tacotron2_ts_config.py --trtis_model_name ${INFER_MODEL_NAME} --out_dir ${OUTPUT_DIR}
