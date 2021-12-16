#!/usr/bin/env bash

set -e

DATADIR="etc"
FILELISTSDIR="etc"

TRAINLIST="$FILELISTSDIR/filelist_jp_final_filtered_train.txt"
VALLIST="$FILELISTSDIR/filelist_jp_final_filtered_val.txt"
TESTLIST="$FILELISTSDIR/filelist_jp_final_filtered_test.txt"

#python preprocess_dataset.py -f "$TRAINLIST" -t -s 5
python preprocess_dataset.py -f "$VALLIST" -t -s 5
python preprocess_dataset.py -f "$TESTLIST" -t -s 5
