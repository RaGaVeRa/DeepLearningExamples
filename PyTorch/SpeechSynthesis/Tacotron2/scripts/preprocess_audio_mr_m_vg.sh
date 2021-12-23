#!/usr/bin/env bash
set -e

DATASET_NAME=mr_m_vg
FILELISTSDIR="${DATASET_NAME}/filelists"

TRAINLIST="$FILELISTSDIR/${DATASET_NAME}_audio_text_train_filelist.txt"
VALLIST="$FILELISTSDIR/${DATASET_NAME}_audio_text_val_filelist.txt"
TESTLIST="$FILELISTSDIR/${DATASET_NAME}_audio_text_test_filelist.txt"

python preprocess_dataset.py -f "$TRAINLIST" -t -s 5
python preprocess_dataset.py -f "$VALLIST" -t -s 5
python preprocess_dataset.py -f "$TESTLIST" -t -s 5
