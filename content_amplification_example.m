function content_amplification_example()

close all

img_name = 'image3.jpg';
img = im2double(imread(img_name));
figure, imagesc(img), axis image;


[h,w,c] = size(img);

% scale it by a factor of 1.2
new_img = imresize(img, 1.2);
figure, imagesc(new_img), axis image;

[nh, nw, c] = size(new_img);

h_diff = nh - h;
w_diff = nw - w;

%% shrinking the image
iter = max(h_diff, w_diff);

img = new_img;
for i = 1:iter
    i

    %% find horizontal seam
    if(i < h_diff)
        [img_grad, img_r, img_g, img_b] = get_rgb_img_gradient(img);
        [mask, bestpath] = cut(img_grad);
        new_img = get_new_shrinked_img(img_r, img_g, img_b, bestpath);
    end
    % figure, imagesc(new_img), axis image;
    
    
    %% find vertical seam   
    if(i < w_diff)
        new_img = imrotate(new_img, 90);
        [img_grad, img_r, img_g, img_b] = get_rgb_img_gradient(new_img);
        [mask, bestpath] = cut(img_grad);
        new_img = get_new_shrinked_img(img_r, img_g, img_b, bestpath);
        new_img = imrotate(new_img, -90);
    end
    img = new_img;
    % figure, imagesc(new_img), axis image;

end

figure, imagesc(new_img), axis image;
a = 1

end
    