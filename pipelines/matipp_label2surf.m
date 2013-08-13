function[] = matipp_label2surf(subjects_dir, log_dir, pipeline_opt)
% Pipeline for convert freesurfer label file to gii surface file.
%
%--------------------------------------------------------------------------
%     wanlin zhu
%     Email : wanlin.zhu@outlook.com
%==========================================================================

%1. add all the tools
[path,~]=fileparts(pwd);
addpath([path, filesep, 'third/psom-1.0']);
addpath([path, filesep, 'utils']);
addpath([path, filesep, 'commands']);

%2. set global variables
psom_gb_vars;

%3. set required global variables
if nargin < 3
    pipeline_opt = struct;
end

[~, name] = system('hostname');


if ~isfield(pipeline_opt,'mode')
    if strcmp(name(1:end-1), 'nil.unsw.edu.au')
        pipeline_opt.mode = 'qsub';
        pipeline_opt.qsub_options = '-q all.q';
    else
        pipeline_opt.mode = 'background';
    end
end

if ~isfield(pipeline_opt,'mode_pipeline_manager')
    pipeline_opt.mode_pipeline_manager = 'batch';
end

if ~isfield(pipeline_opt,'max_queued')
    pipeline_opt.max_queued = 100;
end

if ~isfield(pipeline_opt,'time_between_checks')
    pipeline_opt.time_between_checks = 0.5;
end

if ~isfield(pipeline_opt,'flag_pause')
    pipeline_opt.flag_pause = 0;
end

if ~isfield(pipeline_opt,'flag_verbose')
    pipeline_opt.flag_verbose = 0;
end

pipeline_opt.path_logs = [log_dir filesep 'logs'];

subjects = update_subjects(subjects_dir);
nums = numel(subjects);

hemi = {'lh','rh'};
job_name = {};
for i = 1 : nums
    subj_id = subjects{i};
    for j = 1 : 2
        %1. mris_convert job
        job_name{1} = ['mris_convert_',subj_id,'_',hemi{j}];
        surf_file = [subjects_dir, filesep, subj_id, filesep, 'surf', filesep, hemi{j}, '.white'];
        pipeline.(job_name{1}).command           = 'mris_convert(opt.parameters1, files_out)';
        pipeline.(job_name{1}).opt.parameters1   = surf_file;
        pipeline.(job_name{1}).files_out         = [surf_file, '.gii'];

        %2. mri_annotation2label
        job_name{2} = ['mri_annotation2label_',subj_id,'_',hemi{j}];
        pipeline.(job_name{2}).command           = 'mri_annotation2label(opt.parameters1, opt.parameters2, files_out, opt.parameters3, opt.parameters4)';
        pipeline.(job_name{2}).opt.parameters1   = subjects_dir;
        pipeline.(job_name{2}).opt.parameters2   = subj_id;
        pipeline.(job_name{2}).opt.parameters3   = hemi{j};
        pipeline.(job_name{2}).opt.parameters4   = 'aparc';
        pipeline.(job_name{2}).files_out         = [subjects_dir, filesep, subj_id, filesep, hemi{j}, '_aparc', '_label'];

        %3. label2surf
        job_name{3} = ['label2surf_',subj_id,'_',hemi{j}];
        pipeline.(job_name{3}).command           = 'mkdir(files_out); label2surf(files_in{2}, files_out, files_in{1})';
        pipeline.(job_name{3}).files_in{1}       = pipeline.(job_name{1}).files_out;
        pipeline.(job_name{3}).files_in{2}       = pipeline.(job_name{2}).files_out;
        pipeline.(job_name{3}).files_out         = [subjects_dir, filesep, subj_id, filesep, hemi{j}, '_aparc', '_seeds'];
    end
end

psom_run_pipeline(pipeline,pipeline_opt);


function[subjects] = update_subjects(subjects_dir)
subjects = {};
if ~exist(subjects_dir,'dir')
    return;
end

files = dir(subjects_dir);
num_files = numel(files);
file_names = cell(num_files,1);

for i = 1 : num_files
    file_names{i} = files(i).name;
end

j = 1;
for i = 1 : num_files
    if exist([subjects_dir,filesep, file_names{i}],'dir') == 7 && ~strcmp(file_names{i},'..') && ~strcmp(file_names{i},'.')
        subjects{j} = file_names{i};
        j = j + 1;
    end
end

