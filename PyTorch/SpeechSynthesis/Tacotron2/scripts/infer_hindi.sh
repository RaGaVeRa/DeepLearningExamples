python inference.py --tacotron2 output/checkpoint_Tacotron2_last.pt --waveglow modi_checkpoints/waveglow_14000 --wn-channels 256 -o output/ -i phrases/phrase.txt --fp16 --n-symbols 148
#python inference.py --tacotron2 output/checkpoint_Tacotron2_last.pt --waveglow waveglow_1076430_14000_amp --wn-channels 256 -o output/ -i phrases/phrase.txt --fp16 --n-symbols 148
#python inference.py --tacotron2 output/checkpoint_Tacotron2_last.pt --waveglow nvidia_waveglow256pyt_fp16 --wn-channels 256 -o output/ -i phrases/phrase.txt --fp16 --n-symbols 148
