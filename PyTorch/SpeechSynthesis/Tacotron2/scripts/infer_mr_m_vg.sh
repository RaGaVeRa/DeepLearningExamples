TACOTRON2_CHECKPOINT_NUMBER=6500
WAVEGLOW_CHECKPOINT_NUMBER=15000
OUT_DIR=./output/mr_m_vg/mr_m_vg-infer-tacotron2-waveglow/tacotron2_${TACOTRON2_CHECKPOINT_NUMBER}-waveglow_${WAVEGLOW_CHECKPOINT_NUMBER}
TACOTRON2_CHECKPOINT=./output/mr_m_vg/tacotron2_transferlearn/checkpoint_Tacotron2_${TACOTRON2_CHECKPOINT_NUMBER}.pt
WAVEGLOW_CHECKPOINT=./output/mr_m_vg/waveglow_transferlearn/checkpoint_WaveGlow_${WAVEGLOW_CHECKPOINT_NUMBER}.pt
INPUT_DIR=infer_marathi
mkdir -p ${OUT_DIR}
cp ${INPUT_DIR}/phrases.txt $OUT_DIR/
CMD="python inference.py --tacotron2 ${TACOTRON2_CHECKPOINT} --waveglow ${WAVEGLOW_CHECKPOINT} --wn-channels 256 -o ${OUT_DIR} -i ${INPUT_DIR}/phrases.txt --fp16"
echo $CMD > $OUT_DIR/infer.sh
$CMD
cd $OUT_DIR; git add *; git commit -m"Tacotron2 & Waveglow Inference"; git push
