function [val] = in_cell(element, array)
val = false;

nn = numel(array);
for i = 1 : nn
    if strcmp(element,array{i})
        val = true;
        break;
    end
end