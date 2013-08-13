#!/bin/bash

if [ $# -lt 6  ]
then
  echo " USAGE ::  "
  echo " matipp_thickness_smoothing.sh subj_dir log_dir output_dir order number_iteration template "
  echo " ensure the arguments keep the same order as above example"
  echo " order = [2,3,4,5,6,7]"
  echo " template could be subject as found in $SUBJECTS_DIR or ico"
  echo " NOTE: template ico and number_iteration = 0 are exclusive, you are responsible to make sure they do not appear at the same time"
#  echo " the first 3 templares are required"
#  echo " the default value for order is 7 if not set"
#  echo " the default value of number_iteration is 0, namely using the fwhm to determine the number of iteration"
#  echo " the default template is ico, NOTE: ico and number_iteration = 0 are exclusive, you are responsible to make the not appear at the same time"
  exit 1
fi

SUBJECTS_DIR=$1
LOG_DIR=$2
OUTPUT_DIR=$3
ORDER=$4
NUMBER_ITERATION=$5
TEMPLATE=$6
#echo " addpath('/data/public/wanlin/Works/matipp/pipelines'); matipp_thickness_smoothing('/data/public/test/freesurfer','/data/public/test/log','/data/public/test/out','average'); exit;" | matlab -nojvm -nodisplay -nosplash
echo "addpath('/data/public/wanlin/Works/matipp/pipelines'); matipp_thickness_smoothing('$SUBJECTS_DIR','$LOG_DIR','$OUTPUT_DIR','$ORDER','$NUMBER_ITERATION','$TEMPLATE'); exit;" | matlab -nojvm -nodisplay -nosplash
#echo "addpath('/data/public/wanlin/Works/matipp/pipelines'); matipp_thickness_smoothing('$SUBJECTS_DIR','$LOG_DIR','$OUTPUT_DIR','$ORDER','$NUMBER_ITERATION','$TEMPLATE'); exit;"
#if [ $# -lt 4 ]
#then
#  echo " addpath('/data/public/wanlin/Works/matipp/pipelines'); matipp_thickness_smoothing('$SUBJECTS_DIR','$LOG_DIR','$OUTPUT_DIR'); exit;" | matlab -nojvm -nodisplay -nosplash
#elif [ $# -lt 5 ]
#then
#  echo " addpath('/data/public/wanlin/Works/matipp/pipelines'); matipp_thickness_smoothing('$SUBJECTS_DIR','$LOG_DIR','$OUTPUT_DIR','$ORDER','$NUMBER_ITERATION','$TEMPLATE'); exit;" | matlab -nojvm -nodisplay -nosplash
#fi
