TACOTRON2_CHECKPOINT_NUMBER=6460
WAVEGLOW_CHECKPOINT_NUMBER=14875
OUT_DIR=./output/te_m_rp/te_m_rp-infer-tacotron2-waveglow/tacotron2_${TACOTRON2_CHECKPOINT_NUMBER}-waveglow_${WAVEGLOW_CHECKPOINT_NUMBER}
TACOTRON2_CHECKPOINT=./output/te_m_rp/tacotron2_transferlearn/checkpoint_Tacotron2_${TACOTRON2_CHECKPOINT_NUMBER}.pt
WAVEGLOW_CHECKPOINT=./output/te_m_rp/waveglow_transferlearn/checkpoint_WaveGlow_${WAVEGLOW_CHECKPOINT_NUMBER}.pt
mkdir -p $OUT_DIR
cp infer_telugu/phrases.txt $OUT_DIR/
CMD="python inference.py --tacotron2 ${TACOTRON2_CHECKPOINT} --waveglow ${WAVEGLOW_CHECKPOINT} -d 0.025 --wn-channels 256 -o ${OUT_DIR} -i infer_telugu/phrases.txt --fp16"
echo $CMD > $OUT_DIR/infer.sh
$CMD
cd $OUT_DIR; git add *; git commit -m"Tacotron2 & Waveglow Inference"; git push
