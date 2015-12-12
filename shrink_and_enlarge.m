function shrink_and_enlarge()

close all;

DO_SHRINK = true;
DO_ENLARGE = false;
TARGET_WIDTH = 304;
TARGET_HEIGHT = 456;

image_path = 'images/';
addpath(image_path);

img1_name = 'louvre.jpg';
img1 = im2double(imread(img1_name));
figure, imagesc(img1), axis image;

%% shrinking the image
if DO_SHRINK     
    num_rows_to_shrink = size(img1, 1) - TARGET_HEIGHT;
    num_cols_to_shrink = size(img1, 2) - TARGET_WIDTH;
    
    if num_rows_to_shrink == 0
        %shrinking only columns
        new_img = imrotate(img1, 90);
        for i = 1 : num_cols_to_shrink
            [new_img, ~] = shrink_one_row(new_img);
        end
        new_img = imrotate(new_img, -90);
    
    elseif num_cols_to_shrink == 0
        %shrinking only rows
        new_img = img1;
        for i = 1 : num_rows_to_shrink
            [new_img, ~] = shrink_one_row(new_img);
        end
        
    else
        %shrinking both rows and columns
            
        %table that stores the error cost each step of the way
        T = zeros(num_rows_to_shrink + 1, num_cols_to_shrink + 1);

        %populate first row of T. ie shrinking only columns
        cur_img = imrotate(img1, 90);
        for i = 1 : num_cols_to_shrink
            [cur_img, cost] = shrink_one_row(cur_img);

            T(1, i + 1) = cost + T(1, i);
        end

        %populate the rest of T
        cur_img = img1;
        for i = 2 : num_rows_to_shrink + 1

            [cur_img, cost] = shrink_one_row(cur_img);

            T(i, 1) = cost + T(i - 1, 1);

            new_img = imrotate(cur_img, 90);
            for j = 2 : num_cols_to_shrink + 1
                [new_img, cost] = shrink_one_row(new_img);

                T(i, j) = cost + min([T(i, j - 1), T(i - 1, j)]);
            end
        end

        %route is a matrix telling us whether to remove row or column seam each
        %step of the way
        route = uint8(zeros(num_rows_to_shrink + 1, num_cols_to_shrink + 1));
        current_row = num_rows_to_shrink + 1;
        current_col = num_cols_to_shrink + 1;
        for i = 1 : num_rows_to_shrink + num_cols_to_shrink

            if T(current_row - 1, current_col) < T(current_row, current_col - 1)
                %shrinking by row has less error cost
                current_row = current_row - 1;

                if current_row == 1
                    route(1, 1 : current_col) = 1;
                    break;
                end
            else
                %shrinking by col has less error cost
                current_col = current_col - 1;

                if current_col == 1
                    route(1 : current_row, 1) = 1;
                    break;
                end
            end

            route(current_row, current_col) = 1;
        end

        %based on route, shrink image according to the optimal order
        current_row = 1;
        current_col = 1;
        new_img = img1;
        for i = 1 : num_rows_to_shrink + num_cols_to_shrink
            if route(current_row + 1, current_col) == 1
                %optimal to shrink row
                [new_img, ~] = shrink_one_row(new_img);

                current_row = current_row + 1;

                if current_row == num_rows_to_shrink + 1
                    %everything else to shrink is along col
                    new_img = imrotate(new_img, 90);
                    for j = current_col : num_cols_to_shrink + 1
                        [new_img, ~] = shrink_one_row(new_img);
                    end
                    new_img = imrotate(new_img, -90);

                    break;
                end
            else
                %optimal to shrink col
                new_img = imrotate(new_img, 90);
                [new_img, ~] = shrink_one_row(new_img);
                new_img = imrotate(new_img, -90);

                current_col = current_col + 1;

                if current_col == num_cols_to_shrink + 1
                    %everything else to shrink is along row
                    for j = current_row : num_rows_to_shrink + 1
                        [new_img, ~] = shrink_one_row(new_img);
                    end

                    break;
                end
            end
        end
    end

    %{
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
    %}

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
