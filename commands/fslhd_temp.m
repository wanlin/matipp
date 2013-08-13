function[status, results] = fslhd(input_image, output_file)
% split input image
%
%--------------------------------------------------------------------------
%     wanlin zhu
%     Email : wanlin.zhu@outlook.com
%==========================================================================
command = sprintf('fslhd  %s > %s \n',input_image, output_file);
[status,results] = system(command);

if(~status)
    lines = regexpi(results,'\n','split');
    for k = 1 : numel(lines)
        if regexpi(lines{k},'dim4')
            lines{k} = deblank(lines{k});
            parts = regexpi(lines{i},'\ ','split');
            nd = str2double(parts{end});
            break;
        end
    end
else
    fprintf('fslhd command error \n');
    return;
end

save(output_file,''a'')