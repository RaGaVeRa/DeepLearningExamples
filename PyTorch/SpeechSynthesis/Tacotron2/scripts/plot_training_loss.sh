set -e

usage()
{
	echo "$0 -x <experiment_name> -o <training_output_directory_to_read _log_file_from> -l< training_log_file> -m <model_name> -t <plots_dir_under_experiment_dir> -e <Experiment_parent_folder>"
}

parseArguments()
{
	while getopts ":x:o:l:m:t:e:" opt; do
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
			e)
				EXP_ROOT=${OPTARG}
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

	echo EXPERIMENT_NAME  : ${EXP_NAME}
	echo TRAINING_LOG_DIR : ${TRAINING_LOG_DIR}
	echo TRAIN_LOG_FILE   : ${TRAIN_LOG_FILE}
	echo MODEL_NAME       : ${MODEL_NAME}
	echo OUTDIR           : ${OUTDIR}
	echo EXP_ROOT         : ${EXP_ROOT}

	if [ -z $EXP_NAME ] || [ -z $TRAINING_LOG_DIR ] || [ -z $TRAIN_LOG_FILE ] || [ -z $MODEL_NAME ]
	then
		usage
		exit 1
	fi

	if [[ ! -d ${EXP_ROOT}/${EXP_NAME} ]]
	then
		echo ""
		echo "Error: The git repository ${EXP_NAME} has not been cloned under ${OUTDIR} directory. Clone the directory and rerun this script"
		exit
	fi

	if [[ ! -d ${EXP_ROOT}/${EXP_NAME}/.git ]]
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

	mkdir -p ${EXP_ROOT}/${EXP_NAME}/${TRAINING_LOG_DIR}/

	#Checking if reguired permissions are in place.
	if [[ ! -w ${EXP_ROOT}/${EXP_NAME}/${TRAINING_LOG_DIR}/ ]]
	then
		echo ""
		echo "Error: ${EXP_ROOT}/${EXP_NAME}/${TRAINING_LOG_DIR}/ is not writable"
		exit
	fi

	echo "**loss values will be read from : " ${OUTDIR}/${TRAIN_LOG_FILE}
	echo "**plots and log file will be copied to : " ${EXP_ROOT}/${EXP_NAME}/${TRAINING_LOG_DIR}/

	echo ""
	echo "Good to go? hit <enter>, else CTRL+C"
	read

	if [[ ! -d ${EXP_ROOT}/${EXP_NAME}/${TRAINING_LOG_DIR} ]]
	then
		mkdir -p ${EXP_ROOT}/${EXP_NAME}/${TRAINING_LOG_DIR}
	fi

	export TRAIN_CSV_FILE=/tmp/train.csv
	export TRAIN_PNG_FILE=${EXP_ROOT}/${EXP_NAME}/${TRAINING_LOG_DIR}/train_${MODEL_NAME}.png

	export VAL_CSV_FILE=/tmp/val.csv
	export VAL_PNG_FILE=${EXP_ROOT}/${EXP_NAME}/${TRAINING_LOG_DIR}/val_${MODEL_NAME}.png

	if [[ ${EXP_NAME}"zxzx" == "zxzx" ]]
	then
		echo "Environment variable EXP_NAME not set. Please set it and re-run this script"
		exit
	fi

	grep train_loss ./${OUTDIR}/${TRAIN_LOG_FILE}_* ./${OUTDIR}/${TRAIN_LOG_FILE} | egrep -e"\[[0-9]+\]" | sed -e 's/^.*\[//' | sed -e 's/].*:/,/' | sed -e 's/}}//' > /${TRAIN_CSV_FILE}
	gnuplot <<- EOF                                              
set title "${MODEL_NAME} training loss" 
set term png
set output "$TRAIN_PNG_FILE"
plot "$TRAIN_CSV_FILE" with lines
EOF

  grep val_loss ./${OUTDIR}/${TRAIN_LOG_FILE}_* ./${OUTDIR}/${TRAIN_LOG_FILE} | egrep -e"\[[0-9]+\]" | sed -e 's/^.*\[//' | sed -e 's/].*:/,/' | sed -e 's/}}//' > /${VAL_CSV_FILE}
gnuplot <<- EOF                                              
set title "${MODEL_NAME} validation loss" 
set term png
set output "$VAL_PNG_FILE"
plot "$VAL_CSV_FILE" with lines
EOF

  rm -f ${TRAIN_CSV_FILE} ${VAL_CSV_FILE}

  #cp ${OUTDIR}/${TRAIN_LOG_FILE} ${OUTDIR}/${EXP_NAME}/${TRAINING_LOG_DIR}/
  gzip -k -c ${OUTDIR}/${TRAIN_LOG_FILE} > ${EXP_ROOT}/${EXP_NAME}/${TRAINING_LOG_DIR}/${TRAIN_LOG_FILE}.gz

  #Create Readme.md
  TRAIN_PNG_FILE_BASENAME=$(basename ${TRAIN_PNG_FILE})
  VAL_PNG_FILE_BASENAME=$(basename ${VAL_PNG_FILE})
  cat <<EOFL > ${EXP_ROOT}/${EXP_NAME}/${TRAINING_LOG_DIR}/Readme.md
   ![${TRAIN_PNG_FILE_BASENAME}](${TRAIN_PNG_FILE_BASENAME}) 
   ![${VAL_PNG_FILE_BASENAME}](${VAL_PNG_FILE_BASENAME}) 
EOFL

  cd ${EXP_ROOT}/${EXP_NAME}
  git add *
  git commit -m"training logs"
  git push
}
main $*
