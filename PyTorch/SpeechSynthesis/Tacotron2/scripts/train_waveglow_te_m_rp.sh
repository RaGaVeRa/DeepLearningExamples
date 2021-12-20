export OUTPUT_FOLDER=./output/te_m_rp/waveglow_transferlearn
export NVLOGFILE=nvlog_waveglow_transferlearn_te_m_rp.json

export TZ=Asia/Calcutta
export TIME_YTD=$(date "+%Y_%m_%d_%H_%M")

mkdir -p ${OUTPUT_FOLDER}
if [[ -f ${OUTPUT_FOLDER}/${NVLOGFILE} ]]
then
	mv ${OUTPUT_FOLDER}/${NVLOGFILE} ${OUTPUT_FOLDER}/${NVLOGFILE}_${TIME_YTD}
fi

FILELISTSDIR="te_m_rp/filelists"
TRAIN_FILELIST="$FILELISTSDIR/te_m_rp_audio_text_train_filelist.txt"
VAL_FILELIST="$FILELISTSDIR/te_m_rp_audio_text_val_filelist.txt"
PRETRAINED_WAVEGLOW_CHECKPOINT=checkpoints/sg-kan-waveglow/1/checkpoint_WaveGlow_14350.pt

# Start training from a pre-trained model
python -m multiproc train.py -m WaveGlow -o ./${OUTPUT_FOLDER}/ -lr 1e-4 --epochs 15500 -bs 10 --segment-length 16000 --weight-decay 0 --grad-clip-thresh 65504.0 --cudnn-enabled --cudnn-benchmark --log-file ${NVLOGFILE} --training-files ${TRAIN_FILELIST} --validation-files ${VAL_FILELIST} --wn-channels 256 --amp --epochs-per-checkpoint 25 --checkpoint-path ${PRETRAINED_WAVEGLOW_CHECKPOINT}
# -lr 1e-5
# --grad-clip-thresh 3.4028234663852886e+38 
# --epochs-per-checkpoint 10
Resume training from last checkpoint
# --resume-from-last
