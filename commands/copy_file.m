function[] = copy_file( input_image, output_image )
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

copyfile( input_image, output_iamge )
