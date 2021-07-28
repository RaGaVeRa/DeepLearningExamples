#!/usr/bin/env bash

set -e

DATADIR="tn_filelists"
FILELISTSDIR="tn_filelists"

#TESTLIST="$FILELISTSDIR/sgk_audio_text_test_filelist.txt"
TRAINLIST="$FILELISTSDIR/tn_audio_train_filelist.txt"
VALLIST="$FILELISTSDIR/tn_audio_val_filelist.txt"

#TESTLIST_MEL="$FILELISTSDIR/sgk_mel_text_test_filelist.txt"
TRAINLIST_MEL="$FILELISTSDIR/tn_mel_train_filelist.txt"
VALLIST_MEL="$FILELISTSDIR/tn_mel_val_filelist.txt"

mkdir -p "$DATADIR/mels"
if [ $(ls $DATADIR/mels | wc -l) -ne 13100 ]; then
    python preprocess_audio2mel.py --wav-files "$TRAINLIST" --mel-files "$TRAINLIST_MEL"
    #python preprocess_audio2mel.py --wav-files "$TESTLIST" --mel-files "$TESTLIST_MEL"
    python preprocess_audio2mel.py --wav-files "$VALLIST" --mel-files "$VALLIST_MEL"	
fi	
