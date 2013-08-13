function [] = matipp_data_to_curv(input_data_filename, output_curv_filename)
% generate a mask from input annotation file
%
%--------------------------------------------------------------------------
%     Wanlin Zhu
%     Email : wanlin.zhu@outlook.com
%==========================================================================

[path,~]=fileparts(pwd);
addpath([path, filesep, 'third/freesurfer-5.3.0']);
data = load(input_data_filename);
%write_ascii_curv(data, output_curv_filename);
%write_curv(output_curv_filename, data, 327680);
write_wfile(output_curv_filename, data);
