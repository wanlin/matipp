function[output_image] = eddy_correct(input_image, output_image)
% wrapping eddy_correct command
%
%--------------------------------------------------------------------------
%     wanlin zhu
%     Email : wanlin.zhu@outlook.com
%==========================================================================
command = sprintf('eddy_correct  %s %s 0 \n',input_image, output_image);
fprintf('run command %s\n',command);
system(command);
