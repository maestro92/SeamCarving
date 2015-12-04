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


%% shrinking the image
for i = 1:200
    i
    [img_grad, img_r, img_g, img_b] = get_rgb_img_gradient(img);
%% find horizontal seam
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

%{
%% expanding the image
for i = 1:50
    i
    [img_grad, img_r, img_g, img_b] = get_rgb_img_gradient(img);
%% find horizontal seam
    [mask, bestpath] = cut(img_grad);
    new_img = get_new_enlarged_img(img_r, img_g, img_b, bestpath, mask);
    % figure, imagesc(new_img), axis image;
    
    
%% find vertical seam   
    new_img = imrotate(new_img, 90);
    [img_grad, img_r, img_g, img_b] = get_rgb_img_gradient(new_img);
    [mask, bestpath] = cut(img_grad);
    new_img = get_new_enlarged_img(img_r, img_g, img_b, bestpath, mask);

    new_img = imrotate(new_img, -90);
    img = new_img;
    % figure, imagesc(new_img), axis image;
end
%}
figure, imagesc(new_img), axis image;
a = 1   






