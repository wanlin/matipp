function[output_image] = fsl_average(target_image, source_images, output_image)
% average input images
%
%--------------------------------------------------------------------------
%     wanlin zhu
%     Email : wanlin.zhu@outlook.com
%==========================================================================
num_images = 1 + numel(source_images);
command = sprintf('fslmaths %s %s -div %s %s \n',target_image, source_images, num2str(num_images), output_image);
fprintf('run command : %s\n',command);
system(command);
