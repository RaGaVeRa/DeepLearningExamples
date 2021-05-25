
# Script to convert Tacotron2 checkpoint into torchscript for to be deployed in
# Nvidia Triton inference server
# Also creates config.pbtxt for the model
#Example: bash  scripts/deploy_tacotron2.sh output_tacotron2_transferlearn_sgk/checkpoint_Tacotron2_6475.pt sg-kan-tacotron2 test_deploy

set -e

CHECKPOINT_FILE=$1
INFER_MODEL_NAME=$2
MODELS_ROOT=$3
MODEL_VERSION="${4:-1}"

usage()
{
	echo $0 "<waveglow_pytorch_checkpoint> <infer_model_name> <models_root> [<model_version>]"
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

if [[ -f ${OUTPUT_DIR}/${MODEL_VERSION}/waveglow_fp32.engine ]]
then
	echo "${OUTPUT_DIR}/${MODEL_VERSION}/waveglow_fp32.engine already exists"
	exit 2
fi

mkdir -p ${OUTPUT_DIR}/${MODEL_VERSION}/

# Export model to ONNX
python tensorrt/convert_waveglow2onnx.py --waveglow ${CHECKPOINT_FILE} --config-file config.json --wn-channels 256 -o /tmp/
echo ${CHECKPOINT_FILE} > ${OUTPUT_DIR}/${MODEL_VERSION}/model_info.txt

# Convert ONNX to tensortRT engine
python tensorrt/convert_onnx2trt.py --waveglow /tmp/waveglow.onnx -o ${OUTPUT_DIR}/${MODEL_VERSION}/
rm /tmp/waveglow.onnx

# Create config.pbtxt
python exports/export_waveglow_trt_config.py --trtis_model_name ${INFER_MODEL_NAME} --out_dir ${OUTPUT_DIR}
