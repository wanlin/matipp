#!/bin/bash
#==========================================================================
# Run matlab function with command line
#      Wanlin Zhu
#      National Key Laboratory of Cognitive Neuroscience and Learning
#      Beijing Normal University
#
# ==========================================================================*/
NUMPARAMS=$#

if [ $# -lt 2  ]
then
	echo " USAGE ::  "
	echo " matipp_fmri_prepare.sh subjects_dir log_dir source_dir"
	echo " perform freesurver recon-all "
	exit
fi

SUBJECTS_DIR=$1
LOG_DIR=$2
SOURCE_DIR=$3
PIPELINE_DIR=\'/home/wanlin/Works/Matlab/matipp/pipelines\'

if [ $# -gt 2  ]
then
	echo "addpath($PIPELINE_DIR); cd($PIPELINE_DIR); matipp_recon_all('$SUBJECTS_DIR','$LOG_DIR','$SOURCE_DIR'); exit;" | matlab -singleCompThread -nojvm -nodisplay -nosplash
else
	echo "addpath($PIPELINE_DIR); cd($PIPELINE_DIR); matipp_recon_all('$SUBJECTS_DIR','$LOG_DIR'); exit;" | matlab -singleCompThread -nojvm -nodisplay -nosplash
fi
#echo "addpath('/data/public/wanlin/Works/matipp/pipelines'); matipp_fmri_prepare('$RAW_DIR','$LOG_DIR','$OUT_4D_DIR','$OUT_3D_DIR'); exit;" | matlab -singleCompThread -nojvm -nodisplay -nosplash
#echo "addpath('/data/public/wanlin/Works/matipp/pipelines'); matipp_fmri_prepare('/data/public/test/fmri/orig','/data/public/test/fmri/log/','/data/public/test/fmri/out4','/data/public/test/fmri/out3'); exit;" | matlab -nojvm -nodisplay -nosplash
