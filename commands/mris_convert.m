function[output_surf] = mris_convert(input_surf, output_surf)
% Convert image
%
%--------------------------------------------------------------------------
%     wanlin zhu
%     Email : wanlin.zhu@outlook.com
%==========================================================================
command = sprintf('mris_convert %s %s \n', input_surf, output_surf );
fprintf('run command : %s\n',command);
system(command);
