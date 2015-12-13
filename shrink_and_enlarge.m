function shrink_and_enlarge()

close all;

DO_SHRINK = false;
DO_ENLARGE = true;

image_path = 'images/';
addpath(image_path);

img1_name = 'image1.jpg';
img1 = im2double(imread(img1_name));
figure, imagesc(img1), axis image;

%% shrinking the image
if DO_SHRINK 
    img = img1;
    new_img = 1;

    k = 200

    for i = 1:k
        i

        % find horizontal seam
        [img_grad, img_r, img_g, img_b] = get_rgb_img_gradient(img);
        [mask, bestpath] = cut(img_grad);
        new_img = get_new_shrinked_img(img_r, img_g, img_b, bestpath);
        % figure, imagesc(new_img), axis image;


        % find vertical seam   
        new_img = imrotate(new_img, 90);
        [img_grad, img_r, img_g, img_b] = get_rgb_img_gradient(new_img);
        [mask, bestpath] = cut(img_grad);
        new_img = get_new_shrinked_img(img_r, img_g, img_b, bestpath);

        new_img = imrotate(new_img, -90);
        img = new_img;
        % figure, imagesc(new_img), axis image;
    end

    figure, imagesc(new_img), axis image;
end




%% expanding the image
if DO_ENLARGE
    img = img1;

    [h,w,c] = size(img);

    copy_count = zeros(h,w);
    img = imrotate(img, 90);
    copy_count = imrotate(copy_count, 90);

    k = 150;
    [img_grad, img_r, img_g, img_b] = get_rgb_img_gradient(img);

    figure, imagesc(img_grad), axis image;
    for i = 1:k
        i

        % get the firsk k seams
        [mask, path, seam, copy_count] = cut_enlarge_k_seam(img_grad, copy_count);

        % assigning high cost
        img_grad = img_grad .* (1-seam) + 10000 .* seam;    
    end

    img_r_with_seam = img_r;
    img_g_with_seam = img_g;
    img_b_with_seam = img_b;
    
    img_r_with_seam(copy_count == 1) = 1;
    img_g_with_seam(copy_count == 1) = 0;
    img_b_with_seam(copy_count == 1) = 0;

    img_with_seam = rgb_to_img(img_r_with_seam, img_g_with_seam, img_b_with_seam);
    img_with_seam = imrotate(img_with_seam, -90);
    figure, imagesc(img_with_seam), axis image;
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])

    % assign the new enlarged image
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

                % assign the average of top and below neighbor
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
end
    
    
end
