function[] = matipp_dtifit(source_dir, log_dir, meta_dir, output_dir, temp_dir, pipeline_opt)
% Pipeline for processing input dwi images to get FA etc images.
%
%--------------------------------------------------------------------------
%     wanlin zhu
%     Email : wanlin.zhu@outlook.com
%==========================================================================

% try

%directory which contain original data
if nargin < 1
    source_dir = uigetdir('','Pleae select directory contain images to be processed');
end

if nargin < 2
    log_dir = uigetdir('','Pleae select directory to put log file');
end

if nargin < 3
    meta_dir = uigetdir('','Pleae select directory contain gradients and bvalues to be processed');
end

if nargin < 4
    output_dir = uigetdir('','Pleae select directory where processed data to be saved');
end

if nargin < 5
    temp_dir = output_dir;
end

if nargin < 6
    pipeline_opt = struct;
end

%1. add all the tools
[path,~]=fileparts(pwd);
addpath([path, filesep, 'third/psom-1.0']);
addpath([path, filesep, 'utils']);
addpath([path, filesep, 'commands']);

%2. set global variables
psom_gb_vars;

%3. set required global variables
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


images = update_images(source_dir);
gradients = update_gradients(meta_dir);
bvals = update_bvals(meta_dir);

subj_images = update_subject_files(images);
subj_gradients = update_subject_files(gradients);
ids = fieldnames(subj_images);
num_subjs = numel(ids);

job_name = {4, 1};

for i = 1 : num_subjs
    subj_id = ids{i};
    parts=regexpi(ids{i},'\_','split');
    fprintf('processing subject %s \n',subj_id);

    images = subj_images.(subj_id);

    num_images = numel(images);
    num_splits = num_images;
    job_id = 1;

    %get split_size, given that all the dwi images have the same size
    command = sprintf('fslhd  %s \n',images{1});
    [status,results] = system(command);

    if(~status)
        lines = regexpi(results,'\n','split');
        for k = 1 : numel(lines)
            if regexpi(lines{k},'dim4')
                lines{k} = deblank(lines{k});
                parts = regexpi(lines{k},'\ ','split');
                split_size = str2double(parts{end});
                break;
            end
        end
    else
        fprintf('fslhd command error \n');
        return;
    end

    %1. merge images
    if num_images > 1
        [~,name] = fileparts(images{1});

        pname = regexpi(name,'\.','split');
        parts=regexpi(pname{1},'\_','split');

        if numel(parts) >= 3
            merge_image = [temp_dir,filesep,parts{1},'_',parts{2},'_','merge','.nii.gz'];
        else
            merge_image = [temp_dir,filesep,parts{1},'_','merge','.nii.gz'];
        end

        job_name{job_id} = ['fslmerge_',subj_id];
        pipeline.(job_name{job_id}).command           = 'fslmerge(strjoin(files_in), files_out)';
        pipeline.(job_name{job_id}).files_in          = images;
        pipeline.(job_name{job_id}).files_out         = merge_image;

        job_id = job_id + 1;
    else
        merge_image = images{1};
    end

    %2.eddy correction
    input_image = merge_image;
    [~,name] = fileparts(input_image);
    pname = regexpi(name,'\.','split');
    parts=regexpi(pname{1},'\_','split');
    if strcmp(parts{end},'merge')
        parts{end} = 'eddy';
    else
        if numel(parts) >= 3
            parts = parts(1:3);
            parts{end} = 'eddy';
        else
            parts{end+1} = 'eddy';
        end
    end

    name =strjoin(parts,'_');
    eddy_image = [temp_dir, filesep, name,'.nii.gz'];
    job_name{job_id} = ['eddy_correct_',subj_id];
    pipeline.(job_name{job_id}).command           = 'eddy_correct(files_in, files_out)';
    pipeline.(job_name{job_id}).files_in          = input_image;
    pipeline.(job_name{job_id}).files_out         = eddy_image;
    job_id = job_id + 1;

    %3. split image
    if num_splits > 1
        input_image = eddy_image;
        [~,name] = fileparts(input_image);
        pname = regexpi(name,'\.','split');
        parts = regexpi(pname{1},'\_','split');
        parts{end} = 'split';
        name =strjoin(parts,'_');

        split_images = cell(num_splits,1);
        for j = 1 : num_splits
            output_image = [temp_dir, filesep, name, '_',num2str(j),'.nii.gz'];
            split_images{j} = output_image;
            job_name{job_id} = ['fslsplit_',subj_id,'_',num2str(j)];
            pipeline.(job_name{job_id}).command           = 'fsl_split(files_in, files_out, opt.parameters1, opt.parameters2)';
            pipeline.(job_name{job_id}).files_in          = input_image;
            pipeline.(job_name{job_id}).files_out         = output_image;
            pipeline.(job_name{job_id}).opt.parameters1   = (j - 1) * split_size;
            pipeline.(job_name{job_id}).opt.parameters2   = split_size;
            job_id = job_id + 1;
        end

    else
        split_images = {eddy_image};
    end

    %4. average images
    if num_splits > 1
        input_images = split_images;
        [~,name] = fileparts(input_images{1});
        pname = regexpi(name,'\.','split');
        parts = regexpi(pname{1},'\_','split');
        if numel(parts) >= 3
            parts = parts(1:3);
        end
        parts{end} = 'average';
        name =strjoin(parts,'_');

        k = 1;
        source_images = cell(2 * (num_splits - 1),1);
        for j = 2 : num_splits
            source_images{k} = '-add';
            k = k + 1;
            source_images{k} = input_images{j};
            k = k + 1;
        end

        average_image = [temp_dir, filesep, name,'.nii.gz'];
        job_name{job_id} = ['fsl_average_',subj_id];
        pipeline.(job_name{job_id}).command           = 'fsl_average(files_in, opt.source_images, files_out)';
        pipeline.(job_name{job_id}).files_in          = input_images{1};
        pipeline.(job_name{job_id}).files_out         = average_image;
        pipeline.(job_name{job_id}).opt.source_images = strjoin(source_images);
        job_id = job_id + 1;
    else
        average_image = split_images{1};
    end

    %5. get brain mask
    input_image = average_image;
    [~,name] = fileparts(input_image);
    pname = regexpi(name,'\.','split');
    parts = regexpi(pname{1},'\_','split');
    parts{end} = 'mask';
    name =strjoin(parts,'_');

    mask_image = [temp_dir, filesep, name,'.nii.gz'];
    job_name{job_id} = ['fsl_mask_',subj_id];
    pipeline.(job_name{job_id}).command           = 'fsl_mask(files_in, files_out, opt.fractional)';
    pipeline.(job_name{job_id}).files_in          = input_image;
    pipeline.(job_name{job_id}).files_out         = mask_image;
    pipeline.(job_name{job_id}).opt.fractional    = 0.2;
    job_id = job_id + 1;

    %6. dti fit
    input_image = average_image;
    [~,name] = fileparts(input_image);
    pname = regexpi(name,'\.','split');
    parts = regexpi(pname{1},'\_','split');
    parts{end} = 'dti';
    name =strjoin(parts,'_');

    if isfield(subj_gradients,subj_id)
        job_name{job_id} = ['dtifit_',subj_id];
        output_base_name = [output_dir, filesep, name];
        pipeline.(job_name{job_id}).command              = 'dtifit(files_in{1}, opt.output_base_name, files_in{2}, opt.gradient, opt.bvals)';
        pipeline.(job_name{job_id}).files_in{1}          = average_image;
        pipeline.(job_name{job_id}).files_in{2}          = mask_image;
        pipeline.(job_name{job_id}).opt.output_base_name = output_base_name;
        pipeline.(job_name{job_id}).opt.gradient         = subj_gradients.(subj_id){1};
        pipeline.(job_name{job_id}).opt.bvals            = bvals;
    end

end

psom_run_pipeline(pipeline,pipeline_opt);
%==========================================================================
function [images] = update_images(source_dir)
images = {};
if ~exist(source_dir,'dir')
    return;
end

imageTypes = {'img','nii','img.gz','nii.gz'};
imageDescriptions = {'merge','eddy','split','average'};

files = dir(source_dir);
numFiles = numel(files);
fileNames = cell(numFiles,1);
for i = 1 : numFiles
    fileNames{i} = files(i).name;
end

j = 1;
for i = 1 : numFiles
    file = fileNames{i};
    ffile = [source_dir, filesep,file];
    if ~isdir(ffile)
        names = regexpi(file,'\.','split');
        suffix = names{2:end};
        type = strjoin(suffix,'.');
        if IsInStringCellArray(type, imageTypes)
            ids = regexpi(names{1},'\_','split');
            if ~IsInStringCellArray(ids{end}, imageDescriptions) && numel(ids) >= 2
                if ~IsInStringCellArray(ids{end-1}, imageDescriptions)
                    images{j} = ffile;
                    j = j + 1;
                end
            end
        end
    end
end
%==========================================================================
function [gradients] = update_gradients(source_dir)
gradients = {};
if ~exist(source_dir,'dir')
    return;
end

gradientTypes = {'gradient'};

files = dir(source_dir);
numFiles = numel(files);
fileNames = cell(numFiles,1);
for i = 1 : numFiles
    fileNames{i} = files(i).name;
end

j = 1;
for i = 1 : numFiles
    file = fileNames{i};
    ffile = [source_dir, filesep,file];
    if ~isdir(ffile)
        names = regexpi(file,'\.','split');
        if numel(names) >= 2
            suffix = names{2:end};
            type = strjoin(suffix,'.');
            if IsInStringCellArray(type, gradientTypes)
                ids = regexpi(names{1},'\_','split');
                if numel(ids) >= 2
                    gradients{j} = ffile;
                    j = j + 1;
                end
            end
        end
    end
end
%==========================================================================
function [bvals] = update_bvals(source_dir)
bvals = '';
if ~exist(source_dir,'dir')
    return;
end

files = dir(source_dir);
numFiles = numel(files);
fileNames = cell(numFiles,1);
for i = 1 : numFiles
    fileNames{i} = files(i).name;
end

j = 1;
for i = 1 : numFiles
    file = fileNames{i};
    ffile = [source_dir, filesep,file];
    if ~isdir(ffile)
        [~,name] = fileparts(ffile);
        if strcmp(name,'bvals')
            bvals = ffile;
            break;
        end
    end
end
%==========================================================================
function [subj_files] = update_subject_files(input_files)
subj_files=struct;

num_files = numel(input_files);
for i = 1 : num_files
    [~,name] = fileparts(input_files{i});

    pname = regexpi(name,'\.','split');
    parts=regexpi(pname{1},'\_','split');

    if ~isnan(str2double(parts{1}(1)))
        id = ['a_',parts{1}];%matlab doesn't support struct with field such as '0939', therefore, we plus 'a' to become 'a_0939'
    end

    if isfield(subj_files,id)
        subj_files.(id){numel(subj_files.(id))+1} = input_files{i};
    else
        subj_files.(id) = {};
        subj_files.(id){1} = input_files{i};
    end
end
%==========================================================================
function [val] = IsInStringCellArray(element, array)
val = false;

nn = numel(array);
for i = 1 : nn
    if strcmp(element,array{i})
        val = true;
        break;
    end
end

%==========================================================================
function s = strjoin(terms, delimiter)
if ~iscellstr(terms)
    s = terms;
    return;
end

if nargin < 2
    d = ' ';
else
    d = delimiter;
    assert(ischar(d) && ndims(d) == 2 && size(d,1) <= 1, ...
        'strjoin:invalidarg', ...
        'The delimiter should be a char string.');
end

n = numel(terms);
if n == 0
    s = '';
elseif n == 1
    s = terms{1};
else
    ss = cell(1, 2*n-1);
    ss(1:2:end) = terms;
    [ss{2:2:end}] = deal(d);
    s = [ss{:}];
end
