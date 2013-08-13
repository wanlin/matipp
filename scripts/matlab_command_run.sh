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
X="${1}(${2},${3},${4},${5})"
echo ${X} > matlab_command_${6}.m
${matlab_exec} -nojvm -nodisplay -nosplash < matlab_command_${6}.m
rm matlab_command_${6}.m

