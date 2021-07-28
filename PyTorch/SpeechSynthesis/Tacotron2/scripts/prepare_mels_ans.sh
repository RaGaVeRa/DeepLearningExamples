#!/usr/bin/env bash

set -e

DATADIR="ans_dataset_folder"
FILELISTSDIR="ans_filelists"

TESTLIST="$FILELISTSDIR/ans_audio_test.txt"
TRAINLIST="$FILELISTSDIR/ans_audio_train.txt"
VALLIST="$FILELISTSDIR/ans_audio_val.txt"

TESTLIST_MEL="$FILELISTSDIR/ans_mel_test.txt"
TRAINLIST_MEL="$FILELISTSDIR/ans_mel_train.txt"
VALLIST_MEL="$FILELISTSDIR/ans_mel_val.txt"

mkdir -p "$DATADIR/mels"
if [ $(ls $DATADIR/mels | wc -l) -ne 13100 ]; then
    python preprocess_audio2mel.py --wav-files "$TRAINLIST" --mel-files "$TRAINLIST_MEL"
    python preprocess_audio2mel.py --wav-files "$TESTLIST" --mel-files "$TESTLIST_MEL"
    python preprocess_audio2mel.py --wav-files "$VALLIST" --mel-files "$VALLIST_MEL"	
fi	
