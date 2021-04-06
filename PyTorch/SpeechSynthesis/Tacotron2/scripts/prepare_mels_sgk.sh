#!/usr/bin/env bash

set -e

DATADIR="sgk_dataset_folder"
FILELISTSDIR="sgk_filelists"

TESTLIST="$FILELISTSDIR/sgk_audio_text_test_filelist.txt"
TRAINLIST="$FILELISTSDIR/sgk_audio_text_train_filelist.txt"
VALLIST="$FILELISTSDIR/sgk_audio_text_val_filelist.txt"

TESTLIST_MEL="$FILELISTSDIR/sgk_mel_text_test_filelist.txt"
TRAINLIST_MEL="$FILELISTSDIR/sgk_mel_text_train_filelist.txt"
VALLIST_MEL="$FILELISTSDIR/sgk_mel_text_val_filelist.txt"

mkdir -p "$DATADIR/mels"
if [ $(ls $DATADIR/mels | wc -l) -ne 13100 ]; then
    python preprocess_audio2mel.py --wav-files "$TRAINLIST" --mel-files "$TRAINLIST_MEL"
    python preprocess_audio2mel.py --wav-files "$TESTLIST" --mel-files "$TESTLIST_MEL"
    python preprocess_audio2mel.py --wav-files "$VALLIST" --mel-files "$VALLIST_MEL"	
fi	
