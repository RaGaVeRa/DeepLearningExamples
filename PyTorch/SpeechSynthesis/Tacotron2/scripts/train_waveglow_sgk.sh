export OUTPUT_FOLDER=output_waveglow_transferlearn_sgk
export NVLOGFILE=nvlog_waveglow_transferlearn_sgk.json

export TZ=Asia/Calcutta
export TIME_YTD=$(date "+%Y_%m_%d_%H_%M")

if [[ -f ${OUTPUT_FOLDER}/${NVLOGFILE} ]]
then
	mv ${OUTPUT_FOLDER}/${NVLOGFILE} ${OUTPUT_FOLDER}/${NVLOGFILE}_${TIME_YTD}
fi

mkdir -p ${OUTPUT_FOLDER}
#python -m multiproc train.py -m WaveGlow -o ./output/ -lr 1e-4 --epochs 15500 -bs 8 --segment-length 16000 --weight-decay 0 --grad-clip-thresh 3.4028234663852886e+38 --cudnn-enabled --cudnn-benchmark --log-file nvlog.json

# Start training from a pre-trained model
#python -m multiproc train.py -m WaveGlow -o ./${OUTPUT_FOLDER}/ -lr 1e-4 --epochs 1500 -bs 8 --segment-length 16000 --weight-decay 0 --grad-clip-thresh 65504.0 --cudnn-enabled --cudnn-benchmark --log-file ${NVLOGFILE} --training-files sgk_filelists/sgk_audio_text_train_filelist.txt --validation-files sgk_filelists/sgk_audio_text_val_filelist.txt --wn-channels 256 --amp --epochs-per-checkpoint 25 --text-cleaners basic_cleaners 
python -m multiproc train.py -m WaveGlow -o ./${OUTPUT_FOLDER}/ -lr 1e-4 --epochs 15500 -bs 10 --segment-length 16000 --weight-decay 0 --grad-clip-thresh 65504.0 --cudnn-enabled --cudnn-benchmark --log-file ${NVLOGFILE} --training-files sgk_filelists/sgk_audio_text_train_filelist.txt --validation-files sgk_filelists/sgk_audio_text_val_filelist.txt --wn-channels 256 --amp --epochs-per-checkpoint 25 --text-cleaners basic_cleaners --checkpoint-path checkpoints/waveglow_1076430_14000_amp
#Resume training from last checkpoint
#python -m multiproc train.py -m WaveGlow -o ./output/ -lr 1e-4 --epochs 15500 -bs 8 --segment-length 16000 --weight-decay 0 --grad-clip-thresh 65504.0 --cudnn-enabled --cudnn-benchmark --log-file nvlog.json --training-files filelists/md_audio_text_train.txt --validation-files filelists/md_audio_text_val.txt --wn-channels 256 --amp --epochs-per-checkpoint 10 --resume-from-last
#python -m multiproc train.py -m WaveGlow -o ./output/ -lr 1e-5 --epochs 15500 -bs 4 --segment-length 16000 --weight-decay 0 --grad-clip-thresh 65504.0 --cudnn-enabled --cudnn-benchmark --log-file nvlog.json --training-files filelists/md_audio_text_train.txt --validation-files filelists/md_audio_text_val.txt --wn-channels 256 --amp --epochs-per-checkpoint 10 --resume-from-last
