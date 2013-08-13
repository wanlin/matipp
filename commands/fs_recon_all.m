function[] = fs_recon_all(subjects_dir, subject_id, additional)
% call recon-all
%
%--------------------------------------------------------------------------
%     wanlin zhu
%     Email : wanlin.zhu@outlook.com
%==========================================================================
setenv('SUBJECTS_DIR', subjects_dir);

%additional is something like '-i image1.nii -i image2.nii'
command = sprintf('recon-all -s %s %s %s\n', subject_id, '-all', additional);
fprintf('run command : %s\n',command);
system(command);


