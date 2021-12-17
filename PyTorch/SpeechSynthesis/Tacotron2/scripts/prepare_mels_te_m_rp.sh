#!/usr/bin/env bash

set -e

DATADIR="te_m_rp"
FILELISTSDIR="te_m_rp/filelists"

TRAINLIST="$FILELISTSDIR/te_m_rp_audio_text_train_filelist.txt"
VALLIST="$FILELISTSDIR/te_m_rp_audio_text_val_filelist.txt"
TESTLIST="$FILELISTSDIR/te_m_rp_audio_text_test_filelist.txt"

TRAINLIST_MEL="$FILELISTSDIR/te_m_rp_mel_text_train_filelist.txt"
VALLIST_MEL="$FILELISTSDIR/te_m_rp_mel_text_val_filelist.txt"
TESTLIST_MEL="$FILELISTSDIR/te_m_rp_mel_text_test_filelist.txt"

mkdir -p "$DATADIR/mels"
python preprocess_audio2mel.py --wav-files "$TRAINLIST" --mel-files "$TRAINLIST_MEL"
python preprocess_audio2mel.py --wav-files "$TESTLIST" --mel-files "$TESTLIST_MEL"
python preprocess_audio2mel.py --wav-files "$VALLIST" --mel-files "$VALLIST_MEL"	
