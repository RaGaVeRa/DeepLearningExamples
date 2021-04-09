set -e 

export TZ=Asia/Calcutta

TIME_YTD=$(date "+%Y_%m_%d_%H_%M")

git config --global user.email "anilkumar911@gmail.com"
git config --global user.name "Anil Kumar K K"
git config --global credential.helper store

if [[ ${EXPERIMENT_NAME}"zxzx" == "zxzx" ]]
then
	echo "Environment variable EXPERIMENT_NAME not set. Please set it and re-run this script"
	exit
fi

#check for php
php --version

OUTPUT_FOLDER=output_tacotron2_sgk
if [[ ! -d ${OUTPUT_FOLDER}/${EXPERIMENT_NAME} ]]
then
	echo "The git repository ${EXPERIMENT_NAME} has not been cloned under ./output/ directory. Clone the directory and rerun this script"
	exit
fi

#Text file for inference
#TEXT_FILE=output/${EXPERIMENT_NAME}/kan_infer_phrases.txt
TEXT_FILE=${OUTPUT_FOLDER}/${EXPERIMENT_NAME}/phrases.txt
if [[ ! -f ${TEXT_FILE} ]]
then
	echo "Error: ${TEXT_FILE} not found"
	exit
fi

#Edit below 3 variables before starting inference
INFER_DIR=${OUTPUT_FOLDER}/${EXPERIMENT_NAME}/output_infer_taco125_wg200_${TIME_YTD}
#Checkpoint files
TACO_CHECKPOINT="${OUTPUT_FOLDER}/checkpoint_Tacotron2_125.pt"
WAVEGLOW_CHECKPOINT="output_waveglow_sgk/checkpoint_WaveGlow_200.pt"


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

#cd ${INFER_DIR}
cd ${OUTPUT_FOLDER}/${EXPERIMENT_NAME}
git pull
cd -

cp ${TEXT_FILE} ${INFER_DIR}/

echo "Inference command:" > ${INFER_DIR}/Readme
echo $INFER_CMD >> ${INFER_DIR}/Readme

echo $INFER_CMD >> ${INFER_DIR}/infer.sh

echo "Tacotron2 checkpoint file : " $TACOTRON2_CHECKPOINT_FILE >> ${INFER_DIR}/Readme

echo "Waveglow checkpoint file: " ${WAVEGLOW_CHECKPOINT} >> ${INFER_DIR}/Readme

echo "Running command : ${INFER_CMD}"

time ${INFER_CMD} | tee ${INFER_DIR}/infer.out

#cp ${OUTPUT_FOLDER}/${EXPERIMENT_NAME}/playback_template.html ${INFER_DIR}/playback.html

cd ${OUTPUT_FOLDER}/${EXPERIMENT_NAME}/
php ../../scripts/create_page.php > inference_summary.html

git add *
git commit -m "Inference with ${TACO_CHECKPOINT_FILE} and ${WAVEGLOW_CHECKPOINT_FILE}"
git push
