OUT_DIR=./output/${DATASET_NAME}/${INFER_DIR}/tacotron2_${TACOTRON2_CHECKPOINT_NUMBER}-waveglow_${WAVEGLOW_CHECKPOINT_NUMBER}
TACOTRON2_CHECKPOINT=./output/${DATASET_NAME}/tacotron2_transferlearn/checkpoint_Tacotron2_${TACOTRON2_CHECKPOINT_NUMBER}.pt
WAVEGLOW_CHECKPOINT=./output/${DATASET_NAME}/waveglow_transferlearn/checkpoint_WaveGlow_${WAVEGLOW_CHECKPOINT_NUMBER}.pt
INPUT_PHRASES=infer/${DATASET_NAME}_phrases.txt
mkdir -p $OUT_DIR
cp ${INPUT_PHRASES} $OUT_DIR/
CMD="python inference.py --tacotron2 ${TACOTRON2_CHECKPOINT} --waveglow ${WAVEGLOW_CHECKPOINT} -d 0.025 --wn-channels 256 -o ${OUT_DIR} -i ${INPUT_PHRASES} --fp16"
echo $CMD > $OUT_DIR/infer.sh
$CMD
cd $OUT_DIR; git add *; git commit -m"Tacotron2 & Waveglow Inference"; git push
