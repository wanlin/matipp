function[]=matipp_convert_fsl_gradient_bvals(filename, is_fsl)

if nargin < 2
    is_fsl = true;
end

%1. read input data
mat = importdata(filename);

[path,name] = fileparts(filename);
if strcmp(path, '')
    path = pwd;
end

pname = regexpi(name,'\.','split');
gradient_file = [path, filesep, pname{1}, '.bvec'];
bval_file = [path, filesep, pname{1}, '.bval'];
fid_g = fopen(gradient_file,'w');
fid_b = fopen(bval_file,'w');

num_gradients = size(mat, 1);
%5.for each direction
if is_fsl
    mat = mat';
    for i = 1 : 3
        for j = 1 : size(mat,2)
            fprintf(fid_g,'%f  ',mat(i,j));
        end
    fprintf(fid_g,'\n');
    end

    for j = 1 : size(mat,2)
        fprintf(fid_b,'%d  ',mat(4,j));
    end

    fprintf(fid_b,'\n');
else
    for j = 1 : num_gradients
        fprintf(fid_g,'%f %f %f \n',mat(j,1:3));
        fprintf(fid_b,'%d \n',mat(j,4));
    end
end

fclose(fid_g);
fclose(fid_b);
