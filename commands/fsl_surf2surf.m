function[output_surf] = fsl_surf2surf(input_surf, output_surf, output_type)
% Convert surf to surf
%
%--------------------------------------------------------------------------
%     wanlin zhu
%     Email : wanlin.zhu@outlook.com
%==========================================================================
command = sprintf('surf2surf %s %s --outputtype=%s \n', input_surf, output_surf, output_type );
fprintf('run command : %s\n',command);
system(command);
