#!/usr/bin/env bash

set -e

FILELISTSDIR="te_m_rp/filelists"

TRAINLIST="$FILELISTSDIR/te_m_rp_audio_text_train_filelist.txt"
VALLIST="$FILELISTSDIR/te_m_rp_audio_text_val_filelist.txt"
TESTLIST="$FILELISTSDIR/te_m_rp_audio_text_test_filelist.txt"

python preprocess_dataset.py -f "$TRAINLIST" -t -s 5
python preprocess_dataset.py -f "$VALLIST" -t -s 5
python preprocess_dataset.py -f "$TESTLIST" -t -s 5

