mkdir -p output
#python -m multiproc train.py -m WaveGlow -o ./output/ -lr 1e-4 --epochs 15500 -bs 8 --segment-length 16000 --weight-decay 0 --grad-clip-thresh 3.4028234663852886e+38 --cudnn-enabled --cudnn-benchmark --log-file nvlog.json

# Start training from a pre-trained model
python -m multiproc train.py -m WaveGlow -o ./output/ -lr 1e-4 --epochs 15500 -bs 8 --segment-length 16000 --weight-decay 0 --grad-clip-thresh 65504.0 --cudnn-enabled --cudnn-benchmark --log-file nvlog_waveglow_14000.json --training-files filelists/md_audio_text_train.txt --validation-files filelists/md_audio_text_val.txt --checkpoint-path checkpoints/waveglow_1076430_14000_amp --wn-channels 256 --amp --epochs-per-checkpoint 25 --text-cleaners basic_cleaners 

#Resume training from last checkpoint
#python -m multiproc train.py -m WaveGlow -o ./output/ -lr 1e-4 --epochs 15500 -bs 8 --segment-length 16000 --weight-decay 0 --grad-clip-thresh 65504.0 --cudnn-enabled --cudnn-benchmark --log-file nvlog.json --training-files filelists/md_audio_text_train.txt --validation-files filelists/md_audio_text_val.txt --wn-channels 256 --amp --epochs-per-checkpoint 10 --resume-from-last
#python -m multiproc train.py -m WaveGlow -o ./output/ -lr 1e-5 --epochs 15500 -bs 4 --segment-length 16000 --weight-decay 0 --grad-clip-thresh 65504.0 --cudnn-enabled --cudnn-benchmark --log-file nvlog.json --training-files filelists/md_audio_text_train.txt --validation-files filelists/md_audio_text_val.txt --wn-channels 256 --amp --epochs-per-checkpoint 10 --resume-from-last

