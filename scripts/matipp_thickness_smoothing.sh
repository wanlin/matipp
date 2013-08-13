#!/bin/bash
#==========================================================================
# Run matlab function with command line
#      Wanlin Zhu
#      National Key Laboratory of Cognitive Neuroscience and Learning
#      Beijing Normal University
#      Email : wanlin.zhu@outlook.com
#
# ==========================================================================*/

if [ $# -lt 6  ]
then
  echo " USAGE ::  "
  echo " matipp_thickness_smoothing.sh subj_dir log_dir output_dir order number_iteration template "
  echo " ensure the arguments keep the same order as above example"
  echo " order = [2,3,4,5,6,7]"
  echo " template could be subject as found in $SUBJECTS_DIR or ico"
  echo " NOTE: template ico and number_iteration = 0 are exclusive, you are responsible to make sure they do not appear at the same time"
  exit 1
fi

SUBJECTS_DIR=$1
LOG_DIR=$2
OUTPUT_DIR=$3
ORDER=$4
NUMBER_ITERATION=$5
TEMPLATE=$6
echo "addpath('/data/public/wanlin/Works/matipp/pipelines'); matipp_thickness_smoothing('$SUBJECTS_DIR','$LOG_DIR','$OUTPUT_DIR','$ORDER','$NUMBER_ITERATION','$TEMPLATE'); exit;" | matlab -singleCompThread -nojvm -nodisplay -nosplash

#echo "addpath('/data/public/wanlin/Works/matipp/pipelines'); matipp_thickness_smoothing('/data/wei/OATS/freesurfer20130516','/data/public/OATS/freesurfer_thickness_order4_smoothing_fwhm/logs','/data/public/OATS/freesurfer_thickness_order4_smoothing_fwhm/thickness', 4, 0); exit;" | matlab -nojvm -nodisplay -nosplash
#echo "addpath('/data/public/wanlin/Works/matipp/pipelines'); matipp_thickness_smoothing('/data/wei/OATS/freesurfer20130516','/data/public/OATS/freesurfer_thickness_order4_smoothing2819/logs','/data/public/OATS/freesurfer_thickness_order4_smoothing2819/thickness', 4, 2819); exit;" | matlab -nojvm -nodisplay -nosplash
#echo "addpath('/data/public/wanlin/Works/matipp/pipelines'); matipp_thickness_smoothing('/data/wei/OATS/freesurfer20130516','/data/public/OATS/freesurfer_thickness_order4_smoothing_fwhm/logs','/data/public/OATS/freesurfer_thickness_order4_smoothing_fwhm/thickness', 4, 0, 'average4'); exit;" | matlab -nojvm -nodisplay -nosplash
#echo "addpath('/data/public/wanlin/Works/matipp/pipelines'); matipp_thickness_smoothing('/data/wei/OATS/freesurfer20130516','/data/public/OATS/freesurfer_thickness_order4_smoothing_fwhm/logs','/data/public/OATS/freesurfer_thickness_order4_smoothing_fwhm/thickness', 7, 2819, 'average'); exit;" | matlab -nojvm -nodisplay -nosplash
#echo "addpath('/data/public/wanlin/Works/matipp/pipelines'); matipp_thickness_smoothing('/data/wei/OATS/freesurfer20130516','/data/public/OATS/freesurfer_thickness_order4_smoothing_fwhm/logs','/data/public/OATS/freesurfer_thickness_order4_smoothing_fwhm/thickness', 7, 2819, 'average'); exit;" | matlab -nojvm -nodisplay -nosplash
