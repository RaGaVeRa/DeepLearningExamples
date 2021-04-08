set -e

#export MODEL_NAME
#export TRAINING_LOG_DIR
#export TRAIN_LOG_FILE
#export MODEL_NAME

usage()
{
	echo "$0 -x <experiment_name> -o <training output directory> -l< training_log_file> -m <model_name> -t <training_log_dir>"
}

parseArguments()
{
	while getopts ":x:o:l:m:t:" opt; do
		case "${opt}" in
			x)
				EXP_NAME=${OPTARG}
				;;
			o)
				OUTDIR=${OPTARG}
				;;
			t)
				TRAINING_LOG_DIR=${OPTARG}
				;;
			l)
				TRAIN_LOG_FILE=${OPTARG}
				;;
			m)
				MODEL_NAME=${OPTARG}
				;;
			*)
				usage
				;;
		esac
	done
}

main()
{
	parseArguments $*

	echo EXPERIMENT_NAME : ${EXP_NAME}
	echo TRAINING_LOG_DIR : ${TRAINING_LOG_DIR}
	echo TRAIN_LOG_FILE : ${TRAIN_LOG_FILE}
	echo MODEL_NAME : ${MODEL_NAME}
	echo OUTDIR : ${OUTDIR}

	if [ -z $EXP_NAME ] || [ -z $TRAINING_LOG_DIR ] || [ -z $TRAIN_LOG_FILE ] || [ -z $MODEL_NAME ]
	then
		usage
		exit 1
	fi

	if [[ ! -d ${OUTDIR}/${EXP_NAME} ]]
	then
		echo ""
		echo "Error: The git repository ${EXP_NAME} has not been cloned under ${OUTDIR} directory. Clone the directory and rerun this script"
		exit
	fi

	if [[ ! -d ${OUTDIR}/${EXP_NAME}/.git ]]
	then
		echo ""
		echo "Error: ${OUTDIR}/${EXP_NAME}/ is not a git repository"
		exit
	fi

	if [[ ! -f ${OUTDIR}/${TRAIN_LOG_FILE} ]]
	then
		echo "Error: The training log json file does not exist"
		exit 1
	fi
	#Checking if reguired permissions are in place.
	if [[ ! -w ${OUTDIR}/${EXP_NAME}/${TRAINING_LOG_DIR}/ ]]
	then
		echo ""
		echo "Error: ${OUTDIR}/${EXP_NAME}/${TRAINING_LOG_DIR}/ is not writable"
		exit
	fi

	echo "**loss values will be read from : " ${OUTDIR}/${TRAIN_LOG_FILE}
	echo "**plots and log file will be copied to : " ${OUTDIR}/${EXP_NAME}/${TRAINING_LOG_DIR}/

	echo ""
	echo "Good to go? hit <enter>, else CTRL+C"
	read

	if [[ ! -d ${OUTDIR}/${EXP_NAME}/${TRAINING_LOG_DIR} ]]
	then
		mkdir -p ${OUTDIR}/${EXP_NAME}/${TRAINING_LOG_DIR}
	fi

	export TRAIN_CSV_FILE=/tmp/train.csv
	export TRAIN_PNG_FILE=${OUTDIR}/${EXP_NAME}/${TRAINING_LOG_DIR}/train_${MODEL_NAME}.png

	export VAL_CSV_FILE=/tmp/val.csv
	export VAL_PNG_FILE=${OUTDIR}/${EXP_NAME}/${TRAINING_LOG_DIR}/val_${MODEL_NAME}.png

	if [[ ${EXP_NAME}"zxzx" == "zxzx" ]]
	then
		echo "Environment variable EXP_NAME not set. Please set it and re-run this script"
		exit
	fi

	grep train_loss ./${OUTDIR}/${TRAIN_LOG_FILE}  | egrep -e"\[[0-9]+\]" | sed -e 's/^.*\[//' | sed -e 's/].*:/,/' | sed -e 's/}}//' > /${TRAIN_CSV_FILE}
	gnuplot <<- EOF                                              
set title "${MODEL_NAME} training loss" 
set term png
set output "$TRAIN_PNG_FILE"
plot "$TRAIN_CSV_FILE" with lines
EOF

  grep val_loss ./${OUTDIR}/${TRAIN_LOG_FILE}  | egrep -e"\[[0-9]+\]" | sed -e 's/^.*\[//' | sed -e 's/].*:/,/' | sed -e 's/}}//' > /${VAL_CSV_FILE}
gnuplot <<- EOF                                              
set title "${MODEL_NAME} validation loss" 
set term png
set output "$VAL_PNG_FILE"
plot "$VAL_CSV_FILE" with lines
EOF

  rm -f ${TRAIN_CSV_FILE} ${VAL_CSV_FILE}

  #cp ${OUTDIR}/${TRAIN_LOG_FILE} ${OUTDIR}/${EXP_NAME}/${TRAINING_LOG_DIR}/
  gzip -k -c ${OUTDIR}/${TRAIN_LOG_FILE} > ${OUTDIR}/${EXP_NAME}/${TRAINING_LOG_DIR}/${TRAIN_LOG_FILE}.gz

  #Create Readme.md
  TRAIN_PNG_FILE_BASENAME=$(basename ${TRAIN_PNG_FILE})
  VAL_PNG_FILE_BASENAME=$(basename ${VAL_PNG_FILE})
  cat <<EOFL > ${OUTDIR}/${EXP_NAME}/${TRAINING_LOG_DIR}/Readme.md
   ![${TRAIN_PNG_FILE_BASENAME}](${TRAIN_PNG_FILE_BASENAME}) 
   ![${VAL_PNG_FILE_BASENAME}](${VAL_PNG_FILE_BASENAME}) 
EOFL

  cd ${OUTDIR}/${EXP_NAME}
  git add *
  git commit -m"training logs"
  git push
}
main $*
