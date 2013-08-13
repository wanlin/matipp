function[output_image] = mat_image_split(input_image, output_image, split_start, split_size)
% split input image
%
%--------------------------------------------------------------------------
%     wanlin zhu
%     Email : wanlin.zhu@outlook.com
%==========================================================================
% if nargin < 5
% 	output_type = getenv('FSLOUTPUTTYPE');
% end
% command = sprintf('export FSLOUTPUTTYPE=%s; fslroi  %s %s %s %s \n',output_type, input_image, output_image, num2str(split_start), num2str(split_size));
% fprintf('run command : %s\n',command);
% system(command);

mri = MRIread(input_image);
if numel(size(mri.vol)) > 3 && (mri.nframes >= split_start + split_size - 1)
    data = mri.vol(:,:,:,split_start : split_start + split_size - 1);
    mri.vol = data;
end

mri.fspec = output_image;
MRIwrite(mri, output_image);