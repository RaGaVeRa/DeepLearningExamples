set -e 

TIME_YTD=$(date "+%Y_%m_%d_%H_%M")
INFER_DIR=output_infer_taco700_wg256fp16_${TIME_YTD}

#Checkpoint files
export TACO_CHECKPOINT=output/checkpoint_Tacotron2_last.pt
export WAVEGLOW_CHECKPOINT="nvidia_waveglow256pyt_fp16"

#Text file for inference
TEXT_FILE=phrases/test_phrases.txt

#export INFER_CMD="python inference.py --tacotron2 ${TACO_CHECKPOINT} --waveglow ${WAVEGLOW_CHECKPOINT} --wn-channels 256 -o ${INFER_DIR}/ -i ${TEXT_FILE} --fp16 --n-symbols 148"
export INFER_CMD="python inference.py --tacotron2 ${TACO_CHECKPOINT} --waveglow ${WAVEGLOW_CHECKPOINT} --wn-channels 256 -o ${INFER_DIR}/ -i ${TEXT_FILE} --fp16"

if [[ -d $INFER_DIR ]]
then
	echo "$INFER_DIR already exists. Specify a new directory"
	exit -1
fi
mkdir -p ${INFER_DIR}

if [[ -L ${TACO_CHECKPOINT} ]]
then
	TACOTRON2_CHECKPOINT_FILE=$(ls -l ${TACO_CHECKPOINT} | awk '{print $11}')
else
	TACOTRON2_CHECKPOINT_FILE=${TACO_CHECKPOINT}
fi

cp ${TEXT_FILE} ${INFER_DIR}/

echo "Inference command:" > ${INFER_DIR}/Readme
echo $INFER_CMD >> ${INFER_DIR}/Readme

echo "Tacotron2 checkpoint file : " $TACOTRON2_CHECKPOINT_FILE >> ${INFER_DIR}/Readme

echo "Waveglow checkpoint file: " ${WAVEGLOW_CHECKPOINT} >> ${INFER_DIR}/Readme

echo "Running command : ${INFER_CMD}"

time ${INFER_CMD} | tee ${INFER_DIR}/infer.out

echo "creating archive of inference output..."
echo tar -xzvf ${INFER_DIR}.tgz ${INFER_DIR}
tar -czvf ${INFER_DIR}.tgz ${INFER_DIR}
