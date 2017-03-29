function w=get_weight(given_val,array_val)
% Function make to get weight from an array based on hypo71 format
% 
% Input:  given_val > value to be converted to weight
%         array_val > array containing 4 values to perfrom conversion
% 
% Output: weight > weight in hypo71 format
% 
% Example:  w=get_weight(4,[0 5 10 20]), then because 4 is between 0 and 5, the weigth is 3

%%% Check

if numel(array_val)~=4
    warning('Weighting array must have 4 elements')
    return
end

array_val=sort(array_val);

%%% Start

if given_val<array_val(1)
    w=4;
elseif given_val>=array_val(1) && given_val<array_val(2)
    w=3;
elseif given_val>=array_val(2) && given_val<array_val(3)
    w=2;
elseif given_val>=array_val(3) && given_val<array_val(4)
    w=1;
elseif given_val>=array_val(4)
    w=0;
end


end