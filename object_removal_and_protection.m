function object_removal_and_protection()

close all;

addpath('images');
img_name = 'image4.png';
img = im2double(imread(img_name));
img = img(100:end, 1:1025, :);
img = imresize(img, 0.75);

figure, imagesc(img), axis image;

% choose protection mask
load('image4_mask.mat');
%{
protection_mask = get_mask(img);
removal_mask = get_mask(img);
%}
figure, imagesc(protection_mask), axis image;
figure, imagesc(removal_mask), axis image;



%% shrinking the image

new_img = img; 
i = 0;
%for i = 1:200

[h,w,c] = size(img);
count = size( find(removal_mask == 1), 1);  

start_count = count;


[img_dy, img_dx] = get_img_dx_dy(img);


    new_img = imrotate(new_img, 90);
    protection_mask = imrotate(protection_mask, 90);
    removal_mask = imrotate(removal_mask, 90);
    img_dy = imrotate(img_dy, 90);
    img_dx = imrotate(img_dx, 90);
    
while (count ~= 0)    
    i
    % find vertical seam   
    [img_grad, img_r, img_g, img_b] = get_rgb_img_gradient(new_img);
    img_grad = object_removal_and_protection_set_cost_map(img_grad, protection_mask, removal_mask);
    
    %  figure, imagesc(img_grad), axis image;
    
    [mask, bestpath] = cut(img_grad);
    [new_img, protection_mask, removal_mask, img_dy, img_dx] = object_removal_and_protection_get_new_shrinked_img(img_r, img_g, img_b, ...
                                                                                                bestpath, protection_mask, removal_mask, img_dy, img_dx);
    img = new_img;
    
    
    
    i = i+1;
    
    % some random terminating conditions
    count = size( find(removal_mask == 1), 1)  
    if(count < 0.0025 * start_count)
        break;
    end;
    
    if(i> w/2)
       break; 
    end
    
end

new_img = imrotate(new_img, -90);
protection_mask = imrotate(protection_mask, -90);
removal_mask = imrotate(removal_mask, -90);
img_dy = imrotate(img_dy, -90);
img_dx = imrotate(img_dx, -90);

figure, imagesc(new_img), axis image;

% a = 1;



%% reconstructing image
% load('image5_reconstruct_workspace.mat');
new_img_r = image_reconstruct(new_img, img_dy, img_dx, 1);
new_img_g = image_reconstruct(new_img, img_dy, img_dx, 2);
new_img_b = image_reconstruct(new_img, img_dy, img_dx, 3);

new_img = rgb_to_img(new_img_r, new_img_g, new_img_b);

figure, imagesc(new_img), axis image;
a = 1


    
end



