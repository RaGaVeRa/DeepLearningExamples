export OUTPUT_FOLDER=./output/${DATASET_NAME}/tacotron2_transferlearn
export NVLOGFILE=nvlog_tacotron2_transferlearn_${DATASET_NAME}.json

export TZ=Asia/Calcutta
export TIME_YTD=$(date "+%Y_%m_%d_%H_%M")

mkdir -p ${OUTPUT_FOLDER}
if [[ -f ${OUTPUT_FOLDER}/${NVLOGFILE} ]]
then
	mv ${OUTPUT_FOLDER}/${NVLOGFILE} ${OUTPUT_FOLDER}/${NVLOGFILE}_${TIME_YTD}
fi

echo "Training with Below Symbols:"
echo "================================================"
cat tacotron2/text/symbols.py
echo "================================================"
cp tacotron2/text/symbols.py ${OUTPUT_FOLDER}/symbols.py_${TIME_YTD}

FILELISTSDIR="${DATASET_NAME}/filelists"
TRAIN_FILELIST="$FILELISTSDIR/${DATASET_NAME}_audio_text_train_filelist.txt"
VAL_FILELIST="$FILELISTSDIR/${DATASET_NAME}_audio_text_val_filelist.txt"
PRETRAINED_TACOTRON2_CHECKPOINT=checkpoints/tacotron2_1032590_6000_amp

python -m multiproc train.py -m Tacotron2 -o ${OUTPUT_FOLDER}/ -lr 1e-3 --epochs 7501 -bs 24 --weight-decay 1e-6 --grad-clip-thresh 1.0 --cudnn-enabled --training-files ${TRAIN_FILELIST} --validation-files ${VAL_FILELIST} --log-file ${NVLOGFILE} --anneal-steps 6500 7000 7500 --anneal-factor 0.1 --text-cleaners basic_cleaners --checkpoint-path ${PRETRAINED_TACOTRON2_CHECKPOINT} --drop-text-embedding-weights --epochs-per-checkpoint 10
#python -m multiproc train.py -m Tacotron2 -o ${OUTPUT_FOLDER}/ -lr 1e-3 --epochs 7501 -bs 24 --weight-decay 1e-6 --grad-clip-thresh 1.0 --cudnn-enabled --training-files ${TRAIN_FILELIST} --validation-files ${VAL_FILELIST} --log-file ${NVLOGFILE} --anneal-steps 6500 7000 7500 --anneal-factor 0.1 --text-cleaners basic_cleaners --resume-from-last --epochs-per-checkpoint 10
# -bs 128
# -bs 64
# -bs 32
# --load-mel-from-disk 