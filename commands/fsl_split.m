function[output_image] = fsl_split(input_image, output_image, split_start, split_size, output_type)
% split input image
%
%--------------------------------------------------------------------------
%     wanlin zhu
%     Email : wanlin.zhu@outlook.com
%==========================================================================
if nargin < 5
	output_type = getenv('FSLOUTPUTTYPE');
end
command = sprintf('export FSLOUTPUTTYPE=%s; fslroi  %s %s %s %s \n',output_type, input_image, output_image, num2str(split_start), num2str(split_size));
fprintf('run command : %s\n',command);
system(command);
