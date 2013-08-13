function[centroids]=matipp_label_image_centroids(image_filename, output_file)

[path,~]=fileparts(pwd);
addpath([path, filesep, 'third/freesurfer-5.3.0']);

%1. read input image
mri = MRIread(image_filename);

%2. get image data
data = mri.vol;

%3. get affine matrix
affine = mri.vox2ras1;

%4. get labels
labels = unique(data);

num_labels = numel(labels);
centroids = zeros(3, num_labels - 1);

fid = fopen(output_file,'w');
%5.for each labels
for j = 2 : num_labels
    [I,J,K] = ind2sub(size(data),find(data==labels(j)));
    indices = [J,I,K,ones(numel(I),1)];
    coords = mean(affine * indices', 2);
    centroids(:,j)  = coords(1:end-1);
    fprintf(fid,'%f %f %f \n',centroids(:,j));
end
