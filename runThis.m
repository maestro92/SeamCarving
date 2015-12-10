close all;


image_path = 'images/';
addpath(image_path);

img1_name = 'image1.jpg';
img2_name = 'image2.jpg';

img1 = im2double(imread(img1_name));
% img2 = im2double(imread(img2_name));

figure, imagesc(img1), axis image;
% figure, imagesc(img2), axis image;



img = img1;
new_img = 1;

%{
%% shrinking the image
for i = 1:200
    i

%% find horizontal seam
    [img_grad, img_r, img_g, img_b] = get_rgb_img_gradient(img);
    [mask, bestpath] = cut(img_grad);
    new_img = get_new_shrinked_img(img_r, img_g, img_b, bestpath);
    % figure, imagesc(new_img), axis image;
    
    
%% find vertical seam   
    new_img = imrotate(new_img, 90);
    [img_grad, img_r, img_g, img_b] = get_rgb_img_gradient(new_img);
    [mask, bestpath] = cut(img_grad);
    new_img = get_new_shrinked_img(img_r, img_g, img_b, bestpath);

    new_img = imrotate(new_img, -90);
    img = new_img;
    % figure, imagesc(new_img), axis image;
end
%}

%% expanding the image

[h,w,c] = size(img);

copy_count = zeros(h,w);
img = imrotate(img, 90);
copy_count = imrotate(copy_count, 90);

% expand_cost_inf_mask = zeros(h,w);

k = 150;
[img_grad, img_r, img_g, img_b] = get_rgb_img_gradient(img);

figure, imagesc(img_grad), axis image;
for i = 1:k
    i
    [mask, path, seam, copy_count] = cut_enlarge_k_seam(img_grad, copy_count);
%    img_grad = img_grad .* (1-seam) + Inf .* seam;
    img_grad = img_grad .* (1-seam) + 10000 .* seam;
 %   img_grad(img_grad==0) = Inf;
 %   figure, imagesc(img_grad), axis image;
   % figure, imagesc(copy_count), axis image;
    
end

%{
img_grad = imrotate(img_grad, -90);
copy_count = imrotate(copy_count, -90);

figure, imagesc(img_grad), axis image;
figure, imagesc(copy_count), axis image;
a = 1;
%}

new_img_r = zeros(w+k, h);
new_img_g = zeros(w+k, h);
new_img_b = zeros(w+k, h);

[img_grad, img_r, img_g, img_b] = get_rgb_img_gradient(img);

[h,w,c] = size(img);
for xi = 1:w
    cur_y = 1;
    for yi = 1:h  
        xi
        if(copy_count(yi, xi) == 1)
            new_img_r(cur_y, xi) = img_r(yi, xi);
            new_img_g(cur_y, xi) = img_g(yi, xi);
            new_img_b(cur_y, xi) = img_b(yi, xi);
            cur_y = cur_y + 1;
          
            top_idx = min(yi+1, h);
            below_idx = max(yi-1, 1);
            
            
            new_img_r(cur_y, xi) = (img_r(top_idx, xi) + img_r(yi, xi) + img_r(below_idx, xi)) / 3;
            new_img_g(cur_y, xi) = (img_g(top_idx, xi) + img_g(yi, xi) + img_g(below_idx, xi)) / 3;
            new_img_b(cur_y, xi) = (img_b(top_idx, xi) + img_b(yi, xi) + img_b(below_idx, xi)) / 3;
            cur_y = cur_y + 1;
        else
            new_img_r(cur_y, xi) = img_r(yi, xi);
            new_img_g(cur_y, xi) = img_g(yi, xi);
            new_img_b(cur_y, xi) = img_b(yi, xi);
            cur_y = cur_y + 1;
        end
    end 
end
    

new_img = rgb_to_img(new_img_r, new_img_g, new_img_b);

new_img = imrotate(new_img, -90);

figure, imagesc(new_img), axis image;

a = 1;










%{
for i = 1:150
    i
%% find horizontal seam
    [img_grad, img_r, img_g, img_b] = get_rgb_img_gradient(img);
    
    img_grad = assign_inf_cost(img_grad, expand_cost_inf_mask);
  %  if(i > 0)
  %      figure, imagesc(img_grad), axis image;
  %  end
    [mask, bestpath, seam] = cut_enlarge(img_grad);
    % figure, imagesc(seam), axis image;
    % display(seam);
    % figure, imagesc(seam), axis image;
  
    %{
    temp_img = img;
    temp_img(:,:,1) = 200 .* seam + temp_img(:,:,1) .* (1-seam);
    temp_img(:,:,2) = 200 .* seam + temp_img(:,:,2) .* (1-seam);
    temp_img(:,:,3) = 200 .* seam + temp_img(:,:,3) .* (1-seam);
    
    figure, imagesc(temp_img), axis image;
    %}
    
    [new_img, expand_cost_inf_mask] = get_new_enlarged_img(img_r, img_g, img_b, bestpath, mask, expand_cost_inf_mask);
%    if(i > 20)
        
   %     figure, imagesc(expand_cost_inf_mask), axis image;
 %   end
    % display(new_img);
 %   figure, imagesc(img_grad), axis image;
 %   figure, imagesc(seam), axis image;
    
    [ys, xs] = find(img_grad == Inf);
    
    % figure, imagesc(expand_cost_inf_mask), axis image;
    % overwrite the cost to infinity
    
    img = new_img;

    
    %{
%% find vertical seam   
    new_img = imrotate(new_img, 90);
    [img_grad, img_r, img_g, img_b] = get_rgb_img_gradient(new_img);
    [mask, bestpath] = cut_enlarge(img_grad);
    new_img = get_new_enlarged_img(img_r, img_g, img_b, bestpath, mask);

    new_img = imrotate(new_img, -90);
    img = new_img;
    % figure, imagesc(new_img), axis image;
%}
end
%}
%{
new_img = imrotate(new_img, -90);
img_grad = imrotate(img_grad, -90);
figure, imagesc(new_img), axis image;
figure, imagesc(img_grad), axis image;
%}

a = 1   






