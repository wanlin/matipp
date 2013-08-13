function [] = matipp_modify_annotation(labels, inputAnnotationFileName, outputAnnotationFileName)
%     Wanlin Zhu
%     Email : wanlin.zhu@outlook.com
%==========================================================================
if nargin < 2
   % [inputAnnotationFileName,pathName] = uigetfile('*.annot','Choose input annotation file');
    inputAnnotationFileName = uigetfile('*.annot','Choose input annotation file');
end

if nargin < 3
    outputAnnotationFileName = uiputfile('*.annot','Choose output annotation file');
end

addpath('../third/freesurfer');

%4. read left hemi-sphere anatomical notation file
[~, ll, colortable] = read_annotation(inputAnnotationFileName);
alabel=colortable.table(:,5);

%5. relabel unknown label
if~isempty(logical(ll==0))
    warning('FREESURFER:unlabel','Input annotation contains unknown label. use 1 replace');
    ll(logical(ll==0)) = alabel(1);
end

numl = numel(alabel);
ids = 1:numl;


if iscell(labels)
    n = numel(labels);
    names = labels;
    labels = zeros(n,1);
    for i = 1 : n
        labels(i) = find(strcmp(names{i}, colortable.struct_names));
    end
end


ids(labels) = 0;
ids = ids(logical(ids));

blabel = alabel(ids);

%6. get number of labels
lnuml = numel(blabel);

%7. relabel
for i = 1 : lnuml
    ll(logical(ll == blabel(i))) = 13158600;
end
colortable.table(3,1)=200;
colortable.table(3,2)=200;
colortable.table(3,3)=200;
colortable.orig_tab='/space/amaebi/26/users/buckner_cortical_atlas/scripts/colortable_final.txt';
write_annotation(outputAnnotationFileName, 0:numel(ll)-1, ll, colortable);
