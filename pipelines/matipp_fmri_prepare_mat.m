function[] = matipp_fmri_prepare_mat(source_dir, log_dir, output_4d_dir, output_3d_dir, output_type, pipeline_opt)
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
%3. set required global variables
if nargin < 5
    output_type = 'nii.gz';
end

%3. set required global variables
if nargin < 6
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

images = update_images(source_dir);
nums = numel(images);

job_name = {};
for i = 1 : nums
    ids = regexpi(images{i},'\_','split');
    subj_id = ids{1};

    %1. check the existence of the folder
    subj_4d_dir = [output_4d_dir, filesep, subj_id];
    if exist(subj_4d_dir,'dir') ~= 7
        mkdir(subj_4d_dir);
    end

    subj_3d_dir = [output_3d_dir, filesep, subj_id];
    if exist(subj_3d_dir,'dir') ~= 7
        mkdir(subj_3d_dir);
    end

    %2. get number of splits
    num_splits = get_image_dimension( [source_dir, filesep, images{i}] );

    %3. copy file
    job_id = 1;
    job_name{job_id} = ['copy_image_',subj_id];
    pipeline.(job_name{job_id}).command           = 'copyfile( files_in, files_out )';

    pipeline.(job_name{job_id}).files_in          = [source_dir, filesep, images{i}];
    pipeline.(job_name{job_id}).files_out         = [subj_4d_dir, filesep, images{i}];
    job_id = job_id + 1;

    %4. fsl_split
    pname = regexpi(images{i},'\.','split');
    parts = regexpi(pname{1},'\_','split');
    parts{end} = 'split';
    name =strjoin(parts,'_');

    for j = 1 : num_splits
        output_image = [subj_3d_dir, filesep, name, '_',num2str(j),'.',output_type];
        job_name{job_id} = ['mat_image_split_',subj_id,'_',num2str(j)];
        pipeline.(job_name{job_id}).command           = 'mat_image_split(files_in, files_out, opt.parameters1, opt.parameters2)';
        pipeline.(job_name{job_id}).files_in          = pipeline.(job_name{1}).files_out;
        pipeline.(job_name{job_id}).files_out         = output_image;
        pipeline.(job_name{job_id}).opt.parameters1   = j;
        pipeline.(job_name{job_id}).opt.parameters2   = 1;
        job_id = job_id + 1;
    end

end

psom_run_pipeline(pipeline,pipeline_opt);



function [images] = update_images(source_dir)
images = {};
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

n = 1;
for i = 1 : num_files
    file = file_names{i};
    ffile = [source_dir, filesep, file];
    if ~isdir(ffile)
        names = regexpi(file,'\.','split');
        suffix = names{2:end};
        type = strjoin(suffix,'.');
        if in_cell(type, image_types)
            images{n} = file;
            n = n + 1;
%             ids = regexpi(names{1},'\_','split');
%             if numel(ids) >= 2
%                 id = strjoin(ids(1:2),'_');
%             else
%                 id = ids{1};
%             end
%             if images.isKey(id)
%                 img_files = images(id);
%             else
%                 img_files = {};
%             end
%             img_files = [img_files,'-i ', ffile];
% 
%             images(id) = img_files;
        end
    end
end
