function [] = matipp_annotation_mask(input_annotation_filename, output_mask)
% generate a mask from input annotation file
%
%--------------------------------------------------------------------------
%     Wanlin Zhu
%     Email : wanlin.zhu@outlook.com
%==========================================================================

[path,~]=fileparts(pwd);
addpath([path, filesep, 'third/freesurfer-5.3.0']);

%4. read left hemi-sphere anatomical notation file
%inputFile = [pathName, filesep, inputAnnotationFileName];
[~, label, colortable] = read_annotation(input_annotation_filename);
alabel=colortable.table(:,5);

label(logical(label==0)) = alabel(1);
label(logical(label ~= alabel(1))) = 1;
label(logical(label == alabel(1))) = 0;

save(output_mask, 'label');
