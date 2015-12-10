function [mask, bestpaths, seam] = cut_enlarge(errpatch)
% mask = cut(errpatch)
%
% Computes the minimum cut path from the left to right side of the patch
% 
% Input:
%   errpatch: cost of cutting through each pixel
% Output:
%   mask: a 0-1 mask that indicates which pixels should be on either side
%   of the cut


% create padding on top and bottom with very large cost 
errpatch = [1E10*ones(1, size(errpatch,2)) ; errpatch ; 1E10*ones(1, size(errpatch,2))];
[h, w] = size(errpatch);

path = zeros([h w]);

cost = zeros([h w]);
cost(:, 1) = errpatch(:, 1);
cost([1 end], :) = errpatch([1 end], :);

for x = 2:w  % for each column, compute the cheapest connected path to the left
  % cost of path for each row from left upper/same/lower pixe
    tmp = [cost(1:h-2, x-1) cost(2:h-1, x-1) cost(3:h, x-1)]; 
    [mv, mi] = min(tmp, [], 2);  % mi corresponds to upper/same/lower for each row
    path(2:h-1, x) = (2:(h-1))'+mi-2; % save the next step of the path
    cost(2:h-1, x) = cost(path(2:h-1, x), x-1)+errpatch(2:h-1, x);  % update the minimum costs for each 
end
path = path(2:end-1, :)-1; % remove padding
cost = cost(2:end-1, :);

% create the mask based on the best path
mask = zeros(size(path));
seam = zeros(size(path));
bestpaths = zeros(1, size(path, 2));
[mv, bestpaths(end)] = min(cost(:, end)); 
mask(1:bestpaths(end), end) = 1;
for x = numel(bestpaths):-1:2
    
    bestpaths(x-1) = path(bestpaths(x), x);
    mask(1:bestpaths(x-1), x-1) = 1;
    if(bestpaths(x-1)>0)
        seam(bestpaths(x-1), x-1) = 1;
    end
end

% figure, imagesc(seam), axis image;
mask = ~mask;

