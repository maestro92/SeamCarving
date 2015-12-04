function new_img = get_new_shrinked_img(img_r, img_g, img_b, path)

    [h,w] = size(img_r);


    mask = ones(h*w,1);

    y_ind = path;
    x_ind = 1:w;
    
    % ind = sub2ind([h,w], y_ind, x_ind);
    ind = (x_ind-1) * h + y_ind;
    
    mask(ind,1) = 0;
    mask1 = find(mask==1);
    %mask1 = reshape(mask1, [h-1,w]);
    
    
    [vec_img_r, vec_img_g, vec_img_b] = rgb_to_vec_rgb(img_r, img_g, img_b);
  
    
    vec_img_r_new = vec_img_r(mask1, 1);
    vec_img_g_new = vec_img_g(mask1, 1);
    vec_img_b_new = vec_img_b(mask1, 1);
    
    
    %{
    for j = 1:w
        
        row_num = path(1,j);
        img_r_new(1:row_num-1, j) = img_r(1:row_num-1, j);
        img_r_new(row_num:end, j) = img_r(row_num+1:end, j);
        
        img_g_new(1:row_num-1, j) = img_g(1:row_num-1, j);
        img_g_new(row_num:end, j) = img_g(row_num+1:end, j);
        
        img_b_new(1:row_num-1, j) = img_b(1:row_num-1, j);
        img_b_new(row_num:end, j) = img_b(row_num+1:end, j);
    end
    %}
    % new_img = rgb_to_img(img_r_new, img_g_new, img_b_new);
    new_img = vec_rgb_to_img(vec_img_r_new, vec_img_g_new, vec_img_b_new, h-1, w);
end