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