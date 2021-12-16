OUT_DIR=infer_telugu/telugu-male-jp/tacotron-7500-waveglow-15375/
TACOTRON_CHECKPOINT=./output_tacotron2_transferlearn_jp_te/checkpoint_Tacotron2_7500.pt
WAVEGLOW_CHECKPOINT=output_waveglow_transferlearn_jp/checkpoint_WaveGlow_15375.pt
mkdir -p $OUT_DIR
cp infer_telugu/phrases.txt $OUT_DIR/
#python inference.py --tacotron2 ./output_tacotron2_transferlearn_jp_te/checkpoint_Tacotron2_6180.pt --waveglow checkpoints/sg-kan-waveglow/1/checkpoint_WaveGlow_14350.pt --wn-channels 256 -o infer_telugu/ -i infer_telugu/phrases.txt --fp16
CMD="python inference.py --tacotron2 ${TACOTRON_CHECKPOINT} --waveglow ${WAVEGLOW_CHECKPOINT} --wn-channels 256 -o ${OUT_DIR} -i infer_telugu/phrases.txt --fp16"
echo $CMD > $OUT_DIR/infer.sh
$CMD
cd $OUT_DIR; git add *; git commit -m"bla"; git push
