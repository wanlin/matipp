function[output_image] = fslmerge(input_images, output_image)
% merge multiple images
%
%--------------------------------------------------------------------------
%     wanlin zhu
%     Email : wanlin.zhu@outlook.com
%==========================================================================
command = sprintf('fslmerge -t %s %s \n',output_image, input_images);
fprintf('run command : %s\n',command);
system(command);

