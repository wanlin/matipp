function[] = spmImageWrite(filename, info, image, zipflag)
% NIFTI/ANALYZE Image Read Based on SPM5
% $ Input $
%     -image:      Data matrix of image
%     -info:       Data information, containe output file name
%     -zipflag:    true then output *.nii.gz, otherwise output *.nii
%
% $ Version $
%     2009-05-11
%
% $ Usage $
%      spmImageWrite(info, image)
%
%--------------------------------------------------------------------------
%     wanlin zhu
%     NeuroPsychiatric Institute, Euroa Centre
%     School of Psychiatry
%     University of New South Wales
%     Email : wanlin.zhu@unsw.edu.au
%==========================================================================
if nargin < 2
	error('spmImageWrite require input image info and image matrix');
end

if nargin < 3
    zipflag = false;
end

info.fname = filename;
spm_write_vol(info, image);
filename = info.fname;
if zipflag && exist(filename,'file')
    filename = info.fname;
    gzip(filename);
    delete(filename);
end
