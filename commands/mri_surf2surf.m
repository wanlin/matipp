function[] = mri_surf2surf(subjects_dir, subj_id, hemi, template_name, input_value, input_format, output_value, output_format, fwhm, smoothing, order)
% Convert multiple labels to surfs
%
%--------------------------------------------------------------------------
%     wanlin zhu
%     Email : wanlin.zhu@outlook.com
%==========================================================================
if nargin < 11
    order = '7';
end

setenv('SUBJECTS_DIR', subjects_dir);

%[path,~,ext] = fileparts(output_value);
%output_value = [path, filesep, ext(2:end)];

if str2double(smoothing) <= 0
    command = sprintf('mri_surf2surf --srcsubject %s --hemi %s --sval %s --sfmt %s --trgsubject %s --tval %s --tfmt %s --fwhm-trg %s --trgicoorder %s \n',...
        subj_id, hemi,input_value, input_format, template_name, output_value, output_format, fwhm, order );
else
    command = sprintf('mri_surf2surf --srcsubject %s --hemi %s --sval %s --sfmt %s --trgsubject %s --tval %s --tfmt %s --nsmooth-out %s --trgicoorder %s \n',...
        subj_id, hemi,input_value, input_format, template_name, output_value, output_format, smoothing, order );
end

fprintf('run command : %s\n',command);
system(command);
