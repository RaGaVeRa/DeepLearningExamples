set -e 

export TZ=Asia/Calcutta

TIME_YTD=$(date "+%Y_%m_%d_%H_%M")

#Text file for inference
TEXT_FILE=phrases/test_phrases.txt

if [[ ${EXPERIMENT_NAME}"zxzx" == "zxzx" ]]
then
	echo "Environment variable EXPERIMENT_NAME not set. Please set it and re-run this script"
	exit
fi

if [[ ! -d output/${EXPERIMENT_NAME} ]]
then
	echo "The git repository ${EXPERIMENT_NAME} has not been cloned under ./output/ directory. Clone the directory and rerun this script"
	exit
fi

#Edit below 3 variables before starting inference
INFER_DIR=output/${EXPERIMENT_NAME}/output_infer_taco6900_wg14500_${TIME_YTD}
#Checkpoint files
TACO_CHECKPOINT="output/checkpoint_Tacotron2_6900.pt"
WAVEGLOW_CHECKPOINT="output/checkpoint_WaveGlow_14500.pt"


if [[ -d $INFER_DIR ]]
then
	echo "$INFER_DIR already exists. Specify a new directory"
	exit -1
fi
mkdir -p ${INFER_DIR}

if [[ -L ${TACO_CHECKPOINT} ]]
then
	TACO_CHECKPOINT_FILE=$(ls -l ${TACO_CHECKPOINT} | awk '{print $11}')
else
	TACO_CHECKPOINT_FILE=${TACO_CHECKPOINT}
fi

if [[ -L ${WAVEGLOW_CHECKPOINT} ]]
then
	WAVEGLOW_CHECKPOINT_FILE=$(ls -l ${WAVEGLOW_CHECKPOINT} | awk '{print $11}')
else
	WAVEGLOW_CHECKPOINT_FILE=${WAVEGLOW_CHECKPOINT}
fi

#export INFER_CMD="python inference.py --tacotron2 ${TACO_CHECKPOINT} --waveglow ${WAVEGLOW_CHECKPOINT} --wn-channels 256 -o ${INFER_DIR}/ -i ${TEXT_FILE} --fp16 --n-symbols 148"
export INFER_CMD="python inference.py --tacotron2 ${TACO_CHECKPOINT_FILE} --waveglow ${WAVEGLOW_CHECKPOINT_FILE} --wn-channels 256 -o ${INFER_DIR}/ -i ${TEXT_FILE} --fp16"

cp ${TEXT_FILE} ${INFER_DIR}/

echo "Inference command:" > ${INFER_DIR}/Readme
echo $INFER_CMD >> ${INFER_DIR}/Readme

echo $INFER_CMD >> ${INFER_DIR}/infer.sh

echo "Tacotron2 checkpoint file : " $TACOTRON2_CHECKPOINT_FILE >> ${INFER_DIR}/Readme

echo "Waveglow checkpoint file: " ${WAVEGLOW_CHECKPOINT} >> ${INFER_DIR}/Readme

echo "Running command : ${INFER_CMD}"

time ${INFER_CMD} | tee ${INFER_DIR}/infer.out

cd output/${EXPERIMENT_NAME}/
git add *
git commit -m "Inference with ${TACO_CHECKPOINT_FILE} and ${WAVEGLOW_CHECKPOINT_FILE}"
git push
