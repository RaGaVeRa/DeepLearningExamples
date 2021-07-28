#!/usr/bin/env bash

set -e

DATADIR="sgk_dataset_folder"
FILELISTSDIR="sgk_filelists"

TRAINLIST="$FILELISTSDIR/sgk_audio_text_train_filelist.txt"
VALLIST="$FILELISTSDIR/sgk_audio_text_val_filelist.txt"
TESTLIST="$FILELISTSDIR/sgk_audio_text_test_filelist.txt"

python preprocess_dataset.py -f "$TRAINLIST" -t -s 5
python preprocess_dataset.py -f "$VALLIST" -t -s 5
python preprocess_dataset.py -f "$TESTLIST" -t -s 5
