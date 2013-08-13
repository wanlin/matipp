#!/bin/bash
#==========================================================================
# Run matlab function with command line
#      Wanlin Zhu
#      Euroa Centre
#      NeuroPsychiatric Institute
#      School Of Psychiatry
#      University of New South Wales
#      Email : wanlin.zhu@unsw.edu.au
#      Email : wanlinzhu@gmail.com
#
# This program was written for running the function:
# function[] = create_matFSLJobs(srcDir, metaDir, subjDir, jobFile, errFlag);
# note that there are 5 inputs and one output. Therefore, we have
# X="${1}(${2},${3},${4},${5},${6},${7})", 1 output and 6 inputs. It is
# always n+1.
# ==========================================================================*/
matlab_exec=matlab
echo "addpath('/data/public/wanlin/Works/matipp/pipelines');" > matlab_command_run.m
#echo "matipp_thickness_smoothing('/data/wei/OATS/freesurfer20130516','/data/public/OATS/freesurfer_thickness_order4_smoothing2819/logs','/data/public/OATS/freesurfer_thickness_order4_smoothing2819/thickness', 4, 2819, 'average');">> matlab_command_run.m
#echo "matipp_thickness_smoothing('/data/wei/OATS/freesurfer20130516','/data/public/OATS/freesurfer_thickness_order4_smoothing2819/logs','/data/public/OATS/freesurfer_thickness_order4_smoothing2819/thickness', 4, 2819);">> matlab_command_run.m
echo "matipp_thickness_smoothing('/data/wei/OATS/freesurfer20130516','/data/public/OATS/freesurfer_thickness_order4_smoothing_fwhm/logs','/data/public/OATS/freesurfer_thickness_order4_smoothing_fwhm/thickness', 4, 0);">> matlab_command_run.m
#echo "matipp_thickness_smoothing('/data/wei/OATS/freesurfer20130516','/data/public/OATS/freesurfer_thickness_order7_smoothing2819/logs','/data/public/OATS/freesurfer_thickness_order7_smoothing2819/thickness', 7, 2819, 'average');">> matlab_command_run.m
echo "exit;" >> matlab_command_run.m
${matlab_exec} -singleCompThread -nojvm -nodisplay -nosplash < matlab_command_run.m
rm matlab_command_run.m

