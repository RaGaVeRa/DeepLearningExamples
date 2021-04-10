set -e 

export TZ=Asia/Calcutta

TIME_YTD=$(date "+%Y_%m_%d_%H_%M")

usage()
{
	echo "$0 -x <experiment_name> -o <Tacotron2_training_output_directory> -O <waveglow_training_output_directory> -i<inference_output_directory> -p <phrases_file> -c <Tacotron2_checkpoint_file> -C <Waveglow_checkpoint_file>"
}

parseArguments()
{
	while getopts ":x:o:O:i:p:c:C:" opt; do
		case "${opt}" in
			x)
				EXPERIMENT_NAME=${OPTARG}
				;;
			o)
				TACO2_OUTDIR=${OPTARG}
				;;
			O)
				WAVEGLOW_OUTDIR=${OPTARG}
				;;
			i)
				INFERENCE_OUTDIR=${OPTARG}
				;;
			p)
				TEXT_FILE=${OPTARG}
				;;
			c)
				TACO2_CHECKPOINT=${OPTARG}
				;;
			C)
				WAVEGLOW_CHECKPOINT=${OPTARG}
				;;
			*)
				usage
				exit 1
				;;
		esac
	done
}

main()
{
	parseArguments $*

	echo "EXPERIMENT_NAME     : "${EXPERIMENT_NAME}
	echo "WAVEGLOW_OUTDIR     : "${WAVEGLOW_OUTDIR}
	echo "TACO2_OUTDIR        : "${TACO2_OUTDIR}
	echo "INFERENCE_OUTDIR    : "${INFERENCE_OUTDIR}
	echo "TEXT_FILE           : "${TEXT_FILE}
	echo "TACO2_CHECKPOINT    : "${TACO2_CHECKPOINT}
	echo "WAVEGLOW_CHECKPOINT : "${WAVEGLOW_CHECKPOINT}

	if [ -z $EXPERIMENT_NAME ] || [ -z $WAVEGLOW_OUTDIR ] || [ -z $TACO2_OUTDIR ] || [ -z $INFERENCE_OUTDIR ] || [ -z $TEXT_FILE ] || [ -z $TACO2_CHECKPOINT ] || [ -z $WAVEGLOW_CHECKPOINT ]
	then
		usage
		exit 1
	fi

	git config --global user.email "anilkumar911@gmail.com"
	git config --global user.name "Anil Kumar K K"
	git config --global credential.helper store

	if [[ -z ${EXPERIMENT_NAME} ]]
	then
		echo "Environment variable EXPERIMENT_NAME not set. Please set it and re-run this script"
		exit
	fi

	#check for php
	php --version >/dev/null 2>&1

	if [[ ! -d ${INFERENCE_OUTDIR}/${EXPERIMENT_NAME} ]]
	then
		echo "The git repository ${EXPERIMENT_NAME} has not been cloned under ./output/ directory. Clone the directory and rerun this script"
		exit
	fi

	if [[ ! -f ${TEXT_FILE} ]]
	then
		echo "Error: ${TEXT_FILE} not found"
		exit
	fi


	if [[ -L ${TACO2_OUTDIR}/${TACO2_CHECKPOINT} ]]
	then
		TACO_CHECKPOINT_FILE=$(ls -l ${TACO2_OUTDIR}/${TACO2_CHECKPOINT} | awk '{print $11}')
	else
		TACO_CHECKPOINT_FILE=${TACO2_OUTDIR}/${TACO2_CHECKPOINT}
	fi

	if [[ -L ${WAVEGLOW_OUTDIR}/${WAVEGLOW_CHECKPOINT} ]]
	then
		WAVEGLOW_CHECKPOINT_FILE=$(ls -l ${WAVEGLOW_OUTDIR}/${WAVEGLOW_CHECKPOINT} | awk '{print $11}')
	else
		WAVEGLOW_CHECKPOINT_FILE=${WAVEGLOW_OUTDIR}/${WAVEGLOW_CHECKPOINT}
	fi

	TACO2_CHECKPOINT_tmp=${TACO2_CHECKPOINT%.pt}
	WAVEGLOW_CHECKPOINT_tmp=${WAVEGLOW_CHECKPOINT%.pt}
	INFER_DIR=${INFERENCE_OUTDIR}/${EXPERIMENT_NAME}/infer_${TACO2_CHECKPOINT_tmp#checkpoint_}_${WAVEGLOW_CHECKPOINT_tmp#checkpoint_}_${TIME_YTD}
	if [[ -d $INFER_DIR ]]
	then
		echo "$INFER_DIR already exists. Specify a new directory"
		exit -1
	fi
	mkdir -p ${INFER_DIR}


	INFER_CMD="python inference.py --tacotron2 ${TACO_CHECKPOINT_FILE} --waveglow ${WAVEGLOW_CHECKPOINT_FILE} --wn-channels 256 -o ${INFER_DIR}/ -i ${TEXT_FILE} --fp16"

	#cd ${INFER_DIR}
	cd ${INFERENCE_OUTDIR}/${EXPERIMENT_NAME}
	git pull
	cd -

	cp ${TEXT_FILE} ${INFER_DIR}/

	echo "Inference command:" > ${INFER_DIR}/Readme
	echo $INFER_CMD >> ${INFER_DIR}/Readme
	echo "" >> ${INFER_DIR}/Readme
	echo $* >> ${INFER_DIR}/Readme

	echo $INFER_CMD >> ${INFER_DIR}/infer.sh

	echo "Tacotron2 checkpoint file : " $TACOTRON2_CHECKPOINT_FILE >> ${INFER_DIR}/Readme

	echo "Waveglow checkpoint file: " ${WAVEGLOW_CHECKPOINT} >> ${INFER_DIR}/Readme

	echo "Running command : ${INFER_CMD}"

	echo "Good to go?, hit <ENTER>, else <CTRL+C>"
	read
	time ${INFER_CMD} | tee ${INFER_DIR}/infer.out

	cp ${TEXT_FILE} ${INFERENCE_OUTDIR}/${EXPERIMENT_NAME}/phrases.txt
	cd ${INFERENCE_OUTDIR}/${EXPERIMENT_NAME}/
	php ../../scripts/create_page.php > inference_summary.html

	git add *
	git commit -m "Inference with ${TACO_CHECKPOINT_FILE} and ${WAVEGLOW_CHECKPOINT_FILE}"
	git push
}

main $*
