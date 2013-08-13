function[] = label2surf(label_dir, out_dir, surf)
% Convert multiple labels to surfs
%
%--------------------------------------------------------------------------
%     wanlin zhu
%     Email : wanlin.zhu@outlook.com
%==========================================================================
labels = update_labels(label_dir);
nums = numel(labels);
tmpfile = tempname;
for i = 1 : nums
    fid = fopen(tmpfile,'w');
    fprintf(fid,[label_dir, filesep, labels{i}]);
    fclose(fid);

    outfile = [out_dir, filesep, labels{i}];

    command = sprintf('label2surf --surf=%s --out=%s --labels=%s \n',surf, outfile, tmpfile );
    system(command);
end

if exist(tmpfile,'file') == 2
    delete(tmpfile)
end
%==========================================================================
function [labels] = update_labels(label_dir)
labels = {};
if ~exist(label_dir,'dir')
    return;
end


files = dir(label_dir);
num_files = numel(files);
file_names = cell(num_files,1);
for i = 1 : num_files
    file_names{i} = files(i).name;
end


j = 1;
for i = 1 : num_files
    [~,~,ext] = fileparts(file_names{i});
    if strcmp(ext,'.label')
        labels{j} = file_names{i};
        j = j + 1;
    end
end
