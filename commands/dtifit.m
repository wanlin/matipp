function[] = dtifit(input_image, output_image, mask_image, gradient, bvals)
% fsl dtifit
%
%--------------------------------------------------------------------------
%     wanlin zhu
%     Email : wanlin.zhu@outlook.com
%==========================================================================
command = sprintf('dtifit  --data=%s --out=%s --mask=%s --bvecs=%s --bvals=%s \n',input_image, output_image, mask_image, gradient, bvals);
fprintf('run command : %s\n',command);
system(command);
