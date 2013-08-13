function[dimension] = get_image_dimension( input_image, dim )
%get split_size, given that all the dwi images have the same size

dimension = 0;
if nargin < 2
    dim = 'dim4';
end
 
command = sprintf('fslhd  %s \n',input_image);
[status,results] = system(command);
 
if(~status)
    lines = regexpi(results,'\n','split');
    for k = 1 : numel(lines)
        if regexpi(lines{k},dim)
            lines{k} = deblank(lines{k});
            parts = regexpi(lines{k},'\ ','split');
            dimension = str2double(parts{end});
            break;
        end
    end
else
    fprintf('fslhd command error \n');
    return;
end