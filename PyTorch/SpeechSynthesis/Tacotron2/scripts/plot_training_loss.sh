set -e

OUTDIR=output_tacotron2_sgk
#MODEL_NAME=waveglow #(tacotron | waveglow)
MODEL_NAME=tacotron #(tacotron | waveglow)

TRAINING_LOG_DIR=Tacotron2TrainingLogs

export TRAIN_LOG_FILE=nvlog_tacotron2_sgk.json

export TRAIN_CSV_FILE=/tmp/train.csv
export TRAIN_PNG_FILE=${OUTPUT_FOLDER}/${EXPERIMENT_NAME}/${TRAINING_LOG_DIR}/train_${MODEL_NAME}.png

export VAL_CSV_FILE=/tmp/val.csv
export VAL_PNG_FILE=${OUTPUT_FOLDER}/${EXPERIMENT_NAME}/${TRAINING_LOG_DIR}/val_${MODEL_NAME}.png

if [[ ${EXPERIMENT_NAME}"zxzx" == "zxzx" ]]
then
	echo "Environment variable EXPERIMENT_NAME not set. Please set it and re-run this script"
	exit
fi

if [[ ! -d ${OUTPUT_FOLDER}/${EXPERIMENT_NAME} ]]
then
	echo "The git repository ${EXPERIMENT_NAME} has not been cloned under ./output/ directory. Clone the directory and rerun this script"
	exit
fi

if [[ ! -d ${OUTPUT_FOLDER}/${EXPERIMENT_NAME}/${TRAINING_LOG_DIR} ]]
then
	mkdir -p ${OUTPUT_FOLDER}/${EXPERIMENT_NAME}/${TRAINING_LOG_DIR}
fi

grep train_loss ./${OUTDIR}/${TRAIN_LOG_FILE}  | egrep -e"\[[0-9]+\]" | sed -e 's/^.*\[//' | sed -e 's/].*:/,/' | sed -e 's/}}//' > /${TRAIN_CSV_FILE}
gnuplot <<- EOF                                              
set title "Waveglow training loss" 
set term png
set output "$TRAIN_PNG_FILE"
plot "$TRAIN_CSV_FILE" with lines
EOF

grep val_loss ./${OUTDIR}/${TRAIN_LOG_FILE}  | egrep -e"\[[0-9]+\]" | sed -e 's/^.*\[//' | sed -e 's/].*:/,/' | sed -e 's/}}//' > /${VAL_CSV_FILE}
gnuplot <<- EOF                                              
set title "Waveglow validation loss" 
set term png
set output "$VAL_PNG_FILE"
plot "$VAL_CSV_FILE" with lines
EOF

rm -f ${TRAIN_CSV_FILE} ${VAL_CSV_FILE}

cp ${OUTDIR}/${TRAIN_LOG_FILE} ${OUTPUT_FOLDER}/${EXPERIMENT_NAME}/${TRAINING_LOG_DIR}/

#Create Readme.md
TRAIN_PNG_FILE_BASENAME=$(basename ${TRAIN_PNG_FILE})
VAL_PNG_FILE_BASENAME=$(basename ${VAL_PNG_FILE})
cat <<EOFL > ${OUTPUT_FOLDER}/${EXPERIMENT_NAME}/${TRAINING_LOG_DIR}/Readme.md
 ![${TRAIN_PNG_FILE_BASENAME}](${TRAIN_PNG_FILE_BASENAME}) 
 ![${VAL_PNG_FILE_BASENAME}](${VAL_PNG_FILE_BASENAME}) 
EOFL

cd ${OUTPUT_FOLDER}/${EXPERIMENT_NAME}
git add *
git commit -m"training logs"
git push
