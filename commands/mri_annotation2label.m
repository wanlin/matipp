function[] = mri_annotation2label(subjects_dir, subj_id, out_dir, hemi, annotation)
% Convert multiple labels to surfs
%
%--------------------------------------------------------------------------
%     wanlin zhu
%     Email : wanlin.zhu@outlook.com
%==========================================================================
if nargin < 5
    annotation = 'aparc';
end

setenv('SUBJECTS_DIR', subjects_dir);

command = sprintf('mri_annotation2label --subject %s --hemi %s --annotation %s --outdir %s \n', subj_id, hemi, annotation, out_dir );
fprintf('run command : %s\n',command);
system(command);
