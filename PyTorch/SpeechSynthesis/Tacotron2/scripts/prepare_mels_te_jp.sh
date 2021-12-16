#!/usr/bin/env bash

set -e

DATADIR="etc"
FILELISTSDIR="etc"

#TESTLIST="$FILELISTSDIR/sgk_audio_text_test_filelist.txt"
TRAINLIST="$FILELISTSDIR/filelist_jp_final_filtered_train.txt"
VALLIST="$FILELISTSDIR/filelist_jp_final_filtered_val.txt"

#TESTLIST_MEL="$FILELISTSDIR/sgk_mel_text_test_filelist.txt"
TRAINLIST_MEL="$FILELISTSDIR/filelist_mel_jp_final_filtered_train.txt"
VALLIST_MEL="$FILELISTSDIR/filelist_mel_jp_final_filtered_val.txt"

mkdir -p "$DATADIR/mels"
if [ $(ls $DATADIR/mels | wc -l) -ne 13100 ]; then
    #python preprocess_audio2mel.py --wav-files "$TRAINLIST" --mel-files "$TRAINLIST_MEL"
    #python preprocess_audio2mel.py --wav-files "$TESTLIST" --mel-files "$TESTLIST_MEL"
    python preprocess_audio2mel.py --wav-files "$VALLIST" --mel-files "$VALLIST_MEL"	
fi	
