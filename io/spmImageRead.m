function[image,input] = spmImageRead(fileName)
% NIFTI/ANALYZE Image Read Based on SPM5
% $ Input $
%     - fileName : input image filename. (*.img, *.hdr, *.nii, *.nii.gz)
%
% $ Version $
%     2009-04-24
%
% $ Usage $
%      spmImageRead(inputFileName)
%
%--------------------------------------------------------------------------
%     wanlin zhu
%     NeuroPsychiatric Institute, Euroa Centre
%     School of Psychiatry
%     University of New South Wales
%     Email : wanlin.zhu@unsw.edu.au
%==========================================================================


if nargin < 1
	error('spmImageIO require input file name');
end

%addpath([matlabroot '/toolbox/spm5']);
filename = fileName;
[path,name,ext] = fileparts(fileName);

if strcmp(ext,'.gz')
    filename = [path,filesep,name];
    gunzip(fileName);
    input = spm_vol(filename);
    image = numeric(input.private.dat);
    delete(filename);
else
    input = spm_vol(filename);
    image = numeric(input.private.dat);
end

image(logical(isnan(image))) = 0;
%gzip(filename);
