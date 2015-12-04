function new_img = get_new_enlarged_img(img_r, img_g, img_b, path, mask)

    [h,w] = size(img_r);
    
    mask = 1-mask;
    img_upper_r = img_r .* mask;
    img_upper_g = img_g .* mask;
    img_upper_b = img_b .* mask; 
    
    mask = 1-mask;
    img_lower_r = img_r .* mask;
    img_lower_g = img_g .* mask;
    img_lower_b = img_b .* mask; 
    
    
    y_ind = path;    x_ind = 1:w;
    ind_up  = (x_ind-1) * h + y_ind - 1;
    ind_mid = (x_ind-1) * h + y_ind;
    ind_low = (x_ind-1) * h + y_ind + 1;
    
    [vec_img_r, vec_img_g, vec_img_b] = rgb_to_vec_rgb(img_r, img_g, img_b);

    [img_up_r_value, img_up_g_value, img_up_b_value] = get_vec_value_from_ind(vec_img_r, vec_img_g, vec_img_b, ind_up);
    [img_mid_r_value, img_mid_g_value, img_mid_b_value] = get_vec_value_from_ind(vec_img_r, vec_img_g, vec_img_b, ind_mid); 
    [img_low_r_value, img_low_g_value, img_low_b_value] = get_vec_value_from_ind(vec_img_r, vec_img_g, vec_img_b, ind_low);    
    
    %{
    img_up_r_value = vec_img_r(ind_up,1);
    img_up_g_value = vec_img_g(1,path-1);
    img_up_b_value = vec_img_b(1,path-1);
    
    img_mid_r_value = img_upper_r(1,path);
    img_mid_g_value = img_upper_g(1,path);
    img_mid_b_value = img_upper_b(1,path);
    
    img_low_r_value = img_lower_r(1,path+1);
    img_low_g_value = img_lower_g(1,path+1);
    img_low_b_value = img_lower_b(1,path+1);
    %}
    
    
    img_upper_r = cat(1, img_upper_r, zeros(1, w));
    img_upper_g = cat(1, img_upper_g, zeros(1, w));
    img_upper_b = cat(1, img_upper_b, zeros(1, w));
    
    img_lower_r = cat(1, zeros(1, w), img_lower_r);
    img_lower_g = cat(1, zeros(1, w), img_lower_g);
    img_lower_b = cat(1, zeros(1, w), img_lower_b);
    
    

    new_value_r = (img_up_r_value + img_mid_r_value + img_low_r_value)/3;
    new_value_g = (img_up_g_value + img_mid_g_value + img_low_g_value)/3;
    new_value_b = (img_up_b_value + img_mid_b_value + img_low_b_value)/3;  
    
    
    new_ind = (x_ind-1) * (h+1) + y_ind +1; 
    
    
    
    new_img_r = img_upper_r + img_lower_r;
    new_img_g = img_upper_g + img_lower_g;
    new_img_b = img_upper_b + img_lower_b;
    
    
    [vec_new_img_r, vec_new_img_g, vec_new_img_b] = rgb_to_vec_rgb(new_img_r, new_img_g, new_img_b);
    
    vec_new_img_r(new_ind, 1) = new_value_r;
    vec_new_img_g(new_ind, 1) = new_value_g;
    vec_new_img_b(new_ind, 1) = new_value_b;
    
    %{
    vec_img_r_new = vec_img_r(mask1, 1);
    vec_img_g_new = vec_img_g(mask1, 1);
    vec_img_b_new = vec_img_b(mask1, 1);
    
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
    
    new_img = vec_rgb_to_img(vec_new_img_r, vec_new_img_g, vec_new_img_b, h+1, w);

  %  figure; imagesc(new_img); axis image;
    % new_img = vec_rgb_to_img(vec_img_r_new, vec_img_g_new, vec_img_b_new, h-1, w);
end