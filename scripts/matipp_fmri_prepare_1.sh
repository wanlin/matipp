#!/bin/bash
#==========================================================================
# Run matlab function with command line
#      Wanlin Zhu
#      Euroa Centre
#      NeuroPsychiatric Institute
#      School Of Psychiatry
#      University of New South Wales
#      Email : wanlin.zhu@outlook.com
#
# ==========================================================================*/
NUMPARAMS=$#

if [ $# -lt 3  ]
then
	echo " USAGE ::  "
	echo " matipp_fmri_prepare.sh raw_dir log_dir out_4d_dir out_3d_dir  "
	echo " prepare fmri data "
	exit
fi

raw_dir=$1
log_dir=$2
out_4d_dir=$3
out_3d_dir=$4
echo "addpath('/data/public/wanlin/Works/matipp/pipelines'); matipp_fmri_prepare('$raw_dir','$log_dir','$out_4d_dir','$out_3d_dir'); exit;" | matlab -singleCompThread -nojvm -nodisplay -nosplash
#echo "addpath('/data/public/wanlin/Works/matipp/pipelines'); matipp_fmri_prepare('/data/public/test/fmri/orig','/data/public/test/fmri/log/','/data/public/test/fmri/out4','/data/public/test/fmri/out3'); exit;" | matlab -nojvm -nodisplay -nosplash
