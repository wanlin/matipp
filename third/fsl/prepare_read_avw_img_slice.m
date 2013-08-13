function tmpfname = prepare_read_avw_img_slice(fname)
% tmpfname = PREPARE_READ_AVW_IMG_SLICE(fname)
%
%  This simply takes a .nii or .*.gz file and converts it
%  into a .hdr .img pair, returning the basename of the pair.
%  It is intended to be used together with read_avw_img_slice
%  routine to avoid doing the conversion once per slice.
%  The code using it would look something like
%
%  tmpfname = prepare_read_avw_img_slice(fname).
%  dims = read_avw_hdr(tmpfname);
%  for i=1:dims(3)
%    slicedata = read_avw_img_slice(tmpfname,i);
%    process the data ...
%  end
%  cleanup_read_avw_img_slice(tmpfname);
%

tmpfname = tempname;
command = sprintf('sh -c ". ${FSLDIR}/etc/fslconf/fsl.sh; FSLOUTPUTTYPE=NIFTI_PAIR; export FSLOUTPUTTYPE; LD_LIBRARY_PATH=$FSLDIR/bin $FSLDIR/bin/fslmaths %s %s"\n', fname, tmpfname);
system(command);

