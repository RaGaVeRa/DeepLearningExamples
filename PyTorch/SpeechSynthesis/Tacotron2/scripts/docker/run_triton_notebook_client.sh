docker run -it --rm --network=host --device /dev/snd:/dev/snd -v $PWD:/workspace/speech_ai_demo_TTS/ speech_ai_tts_only:demo bash ./notebooks/triton/run_this.sh
