#!/bin/bash
#==========================================================================
# Run matlab function with command line
#      Wanlin Zhu
#      National Key Laboratory of Cognitive Neuroscience and Learning
#      Beijing Normal University
#
# ==========================================================================*/
NUMPARAMS=$#

if [ $# -lt 4  ]
then
	echo " USAGE ::  "
	echo " matipp_fmri_prepare.sh raw_dir log_dir out_4d_dir out_3d_dir  " 
	echo " prepare fmri data " 
	exit
fi

RAW_DIR=$1
LOG_DIR=$2
OUT_4D_DIR=$3
OUT_3D_DIR=$4
if [ $# -gt 4  ]
then
	OUT_TYPE=$5
	echo "addpath('/data/public/wanlin/Works/matipp/pipelines'); matipp_fmri_prepare('$RAW_DIR','$LOG_DIR','$OUT_4D_DIR','$OUT_3D_DIR','$OUT_TYPE'); exit;" | matlab -singleCompThread -nojvm -nodisplay -nosplash
else
	echo "addpath('/data/public/wanlin/Works/matipp/pipelines'); matipp_fmri_prepare('$RAW_DIR','$LOG_DIR','$OUT_4D_DIR','$OUT_3D_DIR'); exit;" | matlab -singleCompThread -nojvm -nodisplay -nosplash
fi
#echo "addpath('/data/public/wanlin/Works/matipp/pipelines'); matipp_fmri_prepare('$RAW_DIR','$LOG_DIR','$OUT_4D_DIR','$OUT_3D_DIR'); exit;" | matlab -singleCompThread -nojvm -nodisplay -nosplash
#echo "addpath('/data/public/wanlin/Works/matipp/pipelines'); matipp_fmri_prepare('/data/public/test/fmri/orig','/data/public/test/fmri/log/','/data/public/test/fmri/out4','/data/public/test/fmri/out3'); exit;" | matlab -nojvm -nodisplay -nosplash
