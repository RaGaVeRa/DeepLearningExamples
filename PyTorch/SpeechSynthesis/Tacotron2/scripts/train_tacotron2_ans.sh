export OUTPUT_FOLDER=output_tacotron2_transferlearnLJS_ans
export NVLOGFILE=nvlog_tacotron2_transferlearnLJS_ans.json

export TZ=Asia/Calcutta
export TIME_YTD=$(date "+%Y_%m_%d_%H_%M")

if [[ -f ${OUTPUT_FOLDER}/${NVLOGFILE} ]]
then
	mv ${OUTPUT_FOLDER}/${NVLOGFILE} ${OUTPUT_FOLDER}/${NVLOGFILE}_${TIME_YTD}
fi

mkdir -p ${OUTPUT_FOLDER}
echo "Training with Below Symbols:"
echo "================================================"
cat tacotron2/text/symbols.py
echo "================================================"
cp tacotron2/text/symbols.py ${OUTPUT_FOLDER}/symbols.py_${TIME_YTD}

#python -m multiproc train.py -m Tacotron2 -o ./output/ -lr 1e-3 --epochs 7501 -bs 128 --weight-decay 1e-6 --grad-clip-thresh 1.0 --cudnn-enabled --load-mel-from-disk --training-files filelists/md_audio_text_train.txt --validation-files filelists/md_audio_text_val.txt --log-file nvlog.json --anneal-steps 6500 7000 7500 --anneal-factor 0.1 --text-cleaners basic_cleaners --checkpoint-path tacotron2_1032590_6000_amp --drop-text-embedding-weights
#python -m multiproc train.py -m Tacotron2 -o ./output/ -lr 1e-3 --epochs 7501 -bs 64 --weight-decay 1e-6 --grad-clip-thresh 1.0 --cudnn-enabled --training-files filelists/md_audio_text_train.txt --validation-files filelists/md_audio_text_val.txt --log-file nvlog.json --anneal-steps 6500 7000 7500 --anneal-factor 0.1 --text-cleaners basic_cleaners --checkpoint-path tacotron2_1032590_6000_amp --drop-text-embedding-weights
## Start training from md checkpoint
#python -m multiproc train.py -m Tacotron2 -o ./${OUTPUT_FOLDER}/ -lr 1e-3 --epochs 9001 -bs 16 --weight-decay 1e-6 --grad-clip-thresh 1.0 --cudnn-enabled --training-files ans_filelists/ans_audio_train.txt --validation-files ans_filelists/ans_audio_val.txt`` --log-file ${NVLOGFILE} --anneal-steps 8000 8500 9000 --anneal-factor 0.1 --text-cleaners basic_cleaners  --epochs-per-checkpoint 25 --resume-from-last

## Start training from LJS
#python -m multiproc train.py -m Tacotron2 -o ./${OUTPUT_FOLDER}/ -lr 1e-3 --epochs 7501 -bs 16 --weight-decay 1e-6 --grad-clip-thresh 1.0 --cudnn-enabled --training-files ans_filelists/ans_audio_train.txt --validation-files ans_filelists/ans_audio_val.txt`` --log-file ${NVLOGFILE} --anneal-steps 6500 7000 7500 --anneal-factor 0.1 --text-cleaners basic_cleaners  --epochs-per-checkpoint 25 --checkpoint-path checkpoints/tacotron2_1032590_6000_amp --drop-text-embedding-weights

#resume from last
python -m multiproc train.py -m Tacotron2 -o ./${OUTPUT_FOLDER}/ -lr 1e-3 --epochs 7501 -bs 16 --weight-decay 1e-6 --grad-clip-thresh 1.0 --cudnn-enabled --training-files ans_filelists/ans_audio_train.txt --validation-files ans_filelists/ans_audio_val.txt`` --log-file ${NVLOGFILE} --anneal-steps 6500 7000 7500 --anneal-factor 0.1 --text-cleaners basic_cleaners  --epochs-per-checkpoint 25 --resume-from-last
