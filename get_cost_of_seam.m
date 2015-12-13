function [ cost ] = get_cost_of_seam( errpatch, bestpath )
%GET_COST_OF_SEAM Calculates the error cost of the seam
%   Detailed explanation goes here
[h, w] = size(errpatch);

cost = 0;

for i = 1 : w
   cost = cost + errpatch(bestpath(i), i);
end

end

