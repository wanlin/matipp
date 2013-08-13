function[] = fsl_mask(input_image, output_image, fractional)
% split input image
%
%--------------------------------------------------------------------------
%     wanlin zhu
%     Email : wanlin.zhu@outlook.com
%==========================================================================
%Because the bet2 automcatically set the mask image file name. The aim
%of this command is to get the mask image. Therefore, I have to reset
%the name of output image to make the origin output_image is the same
%as the obtained mask image.
pname = regexpi(output_image,'\.','split');
parts = regexpi(pname{1},'\_','split');
parts = parts(1:end-1);
name =strjoin(parts,'_');

command = sprintf('bet2  %s %s -f %s -m \n',input_image, name,num2str(fractional));
fprintf('run command : %s\n',command);
system(command);
