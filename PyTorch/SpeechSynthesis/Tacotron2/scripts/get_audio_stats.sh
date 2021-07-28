for WAV in $(awk -F\| '{print $1}' filelists/md_audio_text_train.txt)
do
  DUR=$(ffmpeg -i $WAV 2>&1 | grep Duration | awk '{print $2}' | awk -F: '{print $3}' | sed -e 's/,//')
  echo $DUR "|" $WAV
done > md_dataset_stats.txt
