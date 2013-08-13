function[] = mris_curv2mat(input_curv, output_mat)
% Convert image
%
%--------------------------------------------------------------------------
%     wanlin zhu
%     Email : wanlin.zhu@outlook.com
%==========================================================================
[curv, ~] = read_curv(input_curv);
save(output_mat, 'curv');

