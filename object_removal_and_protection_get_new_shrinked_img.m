function [new_img, new_protection_mask, new_removal_mask, new_img_dy, new_img_dx] = object_removal_and_protection_get_new_shrinked_img(img_r, img_g, img_b, path, protection_mask, removal_mask, img_dy, img_dx)
    [h,w] = size(img_r);

    mask = ones(h*w,1);

    y_ind = path;
    x_ind = 1:w;
    
    ind = (x_ind-1) * h + y_ind;
    
    mask(ind,1) = 0;
    mask1 = find(mask==1);
    
    [vec_img_r, vec_img_g, vec_img_b] = rgb_to_vec_rgb(img_r, img_g, img_b);
    
    
    vec_protection_mask = img_to_vec_img(protection_mask);
    vec_removal_mask = img_to_vec_img(removal_mask);
    [vec_img_dy_r, vec_img_dy_g, vec_img_dy_b] = rgb_to_vec_rgb(img_dy(:,:,1), img_dy(:,:,2), img_dy(:,:,3));
    [vec_img_dx_r, vec_img_dx_g, vec_img_dx_b] = rgb_to_vec_rgb(img_dx(:,:,1), img_dx(:,:,2), img_dx(:,:,3));
    
    
    %% assigning based on the mask
    vec_img_r_new = vec_img_r(mask1, 1);
    vec_img_g_new = vec_img_g(mask1, 1);
    vec_img_b_new = vec_img_b(mask1, 1);
      
    vec_protection_mask = vec_protection_mask(mask1, 1);
    vec_removal_mask = vec_removal_mask(mask1, 1);
    
    vec_img_dy_r = vec_img_dy_r(mask1, 1);
    vec_img_dy_g = vec_img_dy_g(mask1, 1);
    vec_img_dy_b = vec_img_dy_b(mask1, 1);
    
    vec_img_dx_r = vec_img_dx_r(mask1, 1);
    vec_img_dx_g = vec_img_dx_g(mask1, 1);
    vec_img_dx_b = vec_img_dx_b(mask1, 1);
    

    %% converting vec ones back to normal ones
    new_img = vec_rgb_to_img(vec_img_r_new, vec_img_g_new, vec_img_b_new, h-1, w);
    new_protection_mask = vec_img_to_img(vec_protection_mask, h-1, w);
    new_removal_mask = vec_img_to_img(vec_removal_mask, h-1, w);
    
    new_img_dy = vec_rgb_to_img(vec_img_dy_r, vec_img_dy_g, vec_img_dy_b, h-1, w);
    new_img_dx = vec_rgb_to_img(vec_img_dx_r, vec_img_dx_g, vec_img_dx_b, h-1, w);
end