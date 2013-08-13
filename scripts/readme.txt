smoothing cortical thickness using matipp_thickness_smoothing.sh

usage:
$./matipp_thickness_smoothing.sh

you need specify the
1. SUBJECTS_DIR : /data/wei/OATS/freesurfer20130516
2. logs directory : /data/public/OATS/freesurfer_thickness_order4_smoothing_fwhm/logs
3. thickness directory : /data/public/OATS/freesurfer_thickness_order4_smoothing_fwhm/thickness
4. the order : 4 NOTE : the order and the number of vertices
              Order  Number of Vertices
                0              12
                1              42
                2             162
                3             642
                4            2562
                5           10242
                6           40962
                7          163842
5. the number of iterations: if it is 0, then the number of iteration will be determined by fwhm (30 in the script)
  otherwise it will use the number you input
6. template name : here we did not input the template name, therefore 'ico' was used. You can specify a template name (the template must
  be in the directory $SUBJECTS_DIR). If you want the order works, you must specify a template generated with given order during make_average_subject
  via --ico <ico order> : change order of icosahedron (default=7)


echo "matipp_thickness_smoothing('/data/wei/OATS/freesurfer20130516','/data/public/OATS/freesurfer_thickness_order4_smoothing_fwhm/logs','/data/public/OATS/freesurfer_thickness_order4_smoothing_fwhm/thickness', 4, 0);">> matlab_command_run.m
