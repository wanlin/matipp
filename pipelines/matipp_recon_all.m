function[] = matipp_recon_all(subjects_dir, log_dir, source_dir, pipeline_opt)
% Pipeline for convert freesurfer label file to gii surface file.
%
%--------------------------------------------------------------------------
%     wanlin zhu
%     Email : wanlin.zhu@outlook.com
%==========================================================================

%1. add all the tools
[path,~]=fileparts(pwd);
addpath([path, filesep, 'third/psom-1.0']);
addpath([path, filesep, 'third/freesurfer-5.3.0']);
addpath([path, filesep, 'utils']);
addpath([path, filesep, 'commands']);

%2. set global variables
psom_gb_vars;

% if ~isfield(pipeline_opt,'flag_test')
%     flag_test = false;
% else
%     flag_test = pipeline_opt.flag_test;
%     opt = rmfield(pipeline_opt,'flag_test');
% end

%3. set required global variables
from_raw = true;
if nargin < 3
    from_raw = false;
	source_dir = '';
end

if strcmp(source_dir, subjects_dir)
    from_raw = false;
end

%3. set required global variables
if nargin < 4
    pipeline_opt = struct;
end

[~, name] = system('hostname');


if ~isfield(pipeline_opt,'mode')
    if strcmp(name(1:end-1), 'nil.unsw.edu.au') || strcmp(name(1:end-1), 'S3')
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
  if strcmp(pipeline_opt.mode, 'qsub')
    pipeline_opt.max_queued = 100;
  else
    pipeline_opt.max_queued = feature('numcores')
  end
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



% pipeline_opt.mode = 'qsub';
% pipeline_opt.qsub_options = '-q all.q';
% pipeline_opt.mode_pipeline_manager = 'batch';
% pipeline_opt.max_queued = 100;
% pipeline_opt.flag_verbose = 0;
% pipeline_opt.flag_pause = 0;
pipeline_opt.path_logs = [log_dir filesep 'logs'];

if from_raw
    subjects = update_images(source_dir);
else
    subjects = update_subjects(subjects_dir);
end


job_name = {};

ids = subjects.keys();
for i = 1 : numel(ids)
    subj_id = ids{i};
    %1. mris_convert job
    job_name{1} = ['recon_all_',subj_id];
    pipeline.(job_name{1}).command           = 'fs_recon_all(opt.parameters1, opt.parameters2, opt.parameters3)';
    pipeline.(job_name{1}).opt.parameters1   = subjects_dir;
    pipeline.(job_name{1}).opt.parameters2   = subj_id;
    if from_raw
        pipeline.(job_name{1}).opt.parameters3 = subjects(subj_id);
    else
        pipeline.(job_name{1}).opt.parameters3 = '';
    end
    pipeline.(job_name{1}).files_out         = [subjects_dir, filesep, subj_id];
end

psom_run_pipeline(pipeline,pipeline_opt);


function[subjects] = update_subjects(subjects_dir)
subjects = containers.Map;
if ~exist(subjects_dir,'dir')
    return;
end

files = dir(subjects_dir);
num_files = numel(files);
file_names = cell(num_files,1);

for i = 1 : num_files
    file_names{i} = files(i).name;
end

for i = 1 : num_files
    if exist([subjects_dir,filesep, file_names{i}],'dir') == 7 && ~strcmp(file_names{i},'..') && ~strcmp(file_names{i},'.')
        subjects(file_names{i}) = file_names{i};
    end
end


function [image_arguments] = update_images(source_dir)
images = containers.Map;
if ~exist(source_dir,'dir')
    return;
end

image_types = {'img','nii','img.gz','nii.gz'};

files = dir(source_dir);
num_files = numel(files);
file_names = cell(num_files,1);
for i = 1 : num_files
    file_names{i} = files(i).name;
end

for i = 1 : num_files
    file = file_names{i};
    ffile = [source_dir, filesep, file];
    if ~isdir(ffile)
        names = regexpi(file,'\.','split');
        suffix = names{2:end};
        type = strjoin(suffix,'.');
        if in_cell(type, image_types)
            ids = regexpi(names{1},'\_','split');
            if numel(ids) >= 2
                id = strjoin(ids(1:2),'_');
            else
                id = ids{1};
            end

            if images.isKey(id)
                img_files = images(id);
            else
                img_files = {};
            end

            img_files = [img_files,'-i ', ffile];

            images(id) = img_files;
        end
    end
end

image_arguments = containers.Map;
ids = images.keys();
for i = 1 : numel(ids)
    files = images(ids{i});
    image_arguments(ids{i}) = strjoin(files);
end
