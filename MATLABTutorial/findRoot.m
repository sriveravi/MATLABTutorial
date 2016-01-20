% given a continuous increasing function which crosses 0 in
%  the specified range, find the position of the crossing 0 within the
%  range using binary search. (Look at entire range, then keep cutting
%  range in half until you are close enough )

function x0 = findRoot( functHandle, range, eps )

x0 = 1;
% functHandle(x0)