function[] = matipp_thickness_smoothing(subjects_dir, log_dir, output_dir, order, number_iteration, template_name, pipeline_opt)
% Pipeline for smoothing cortical thickness.
%
%--------------------------------------------------------------------------
%     wanlin zhu
%     Email : wanlin.zhu@outlook.com
%==========================================================================

%1. add all the tools
%cwd = pwd;
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

if nargin < 4
    order = 7;
end

if nargin < 5
    number_iteration = 0;
end

if nargin < 6
    template_name = 'ico';
end

%3. set required global variables
if nargin < 7
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
    pipeline_opt.max_queued = 80;
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

subjects = update_subjects(subjects_dir, template_name);
nums = numel(subjects);

hemi = {'lh','rh'};
job_name = {};
for i = 1 : nums
    subj_id = subjects{i};
    for j = 1 : 2

        %1. mri_surf2surf
        job_name{1} = ['mri_surf2surf_',subj_id,'_',hemi{j}];
        pipeline.(job_name{1}).command           = ...
            'mri_surf2surf(opt.parameters1, opt.parameters2, opt.parameters3, opt.parameters4, opt.parameters5, opt.parameters6, files_out, opt.parameters7, opt.parameters8, opt.parameters9, opt.parameters10)';
        pipeline.(job_name{1}).opt.parameters1   = subjects_dir;
        pipeline.(job_name{1}).opt.parameters2   = subj_id;
        pipeline.(job_name{1}).opt.parameters3   = hemi{j};
        pipeline.(job_name{1}).opt.parameters4   = template_name;
        pipeline.(job_name{1}).opt.parameters5   = 'thickness';
        pipeline.(job_name{1}).opt.parameters6   = 'curv';
        pipeline.(job_name{1}).opt.parameters7   = 'curv';
        pipeline.(job_name{1}).opt.parameters8   = '30';
        pipeline.(job_name{1}).opt.parameters9   = num2str(number_iteration);% set this value to 0, it will use fwhm (automatic calculate the number of iterations)
        pipeline.(job_name{1}).opt.parameters10  = num2str(order);%order == '7' is the default, 163842 points.
%        pipeline.(job_name{1}).files_out         = [subjects_dir, filesep, subj_id, filesep, 'surf', filesep, hemi{j}, '.thickness_', template_name];
%        pipeline.(job_name{1}).files_out         = [output_dir, filesep,
%        subj_id, '_', hemi{j}, '.thickness_', template_name];mri_surf2surf
%        automatically ad hemi in the output filename.
        pipeline.(job_name{1}).files_out         = [output_dir, filesep, hemi{j}, '.', subj_id, '_thickness_', template_name];

        %2. mris_curv2mat
        job_name{2} = ['mris_curv2mat_',subj_id,'_',hemi{j}];
        pipeline.(job_name{2}).command           = 'mris_curv2mat(files_in, files_out)';
        pipeline.(job_name{2}).files_in          = pipeline.(job_name{1}).files_out;
        pipeline.(job_name{2}).files_out         = [output_dir, filesep, subj_id, '_', hemi{j}, '_thickness_', template_name, '.mat'];
    end
end

psom_run_pipeline(pipeline,pipeline_opt);


function[subjects] = update_subjects(subjects_dir, template_name)
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
    if exist([subjects_dir,filesep, file_names{i}],'dir') == 7 && ~strcmp(file_names{i},'..') && ~strcmp(file_names{i},'.') && ~strcmp(file_names{i}, template_name)
        subjects{j} = file_names{i};
        j = j + 1;
    end
end

