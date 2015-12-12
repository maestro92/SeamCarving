function [ img, cost ] = shrink_one_row( img )
%SHRINK_ONE_ROW Shrink the image by one row seam, returns the new image and
%the cost of the seam
%   Detailed explanation goes here

[img_grad, img_r, img_g, img_b] = get_rgb_img_gradient(img);
[~, bestpath] = cut(img_grad);
img = get_new_shrinked_img(img_r, img_g, img_b, bestpath);
cost = get_cost_of_seam(img_grad, bestpath);

end