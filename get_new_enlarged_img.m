function [new_img, new_expand_cost_inf_mask] = get_new_enlarged_img(img_r, img_g, img_b, path, mask, expand_cost_inf_mask)

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

    %% getting the above and below neighbor
    [img_up_r_value, img_up_g_value, img_up_b_value] = get_vec_value_from_ind(vec_img_r, vec_img_g, vec_img_b, ind_up);
    [img_mid_r_value, img_mid_g_value, img_mid_b_value] = get_vec_value_from_ind(vec_img_r, vec_img_g, vec_img_b, ind_mid); 
    [img_low_r_value, img_low_g_value, img_low_b_value] = get_vec_value_from_ind(vec_img_r, vec_img_g, vec_img_b, ind_low);    
    

    %% resize the upper_half image to the enlarged size
    img_upper_r = cat(1, img_upper_r, zeros(1, w));
    img_upper_g = cat(1, img_upper_g, zeros(1, w));
    img_upper_b = cat(1, img_upper_b, zeros(1, w));
    
    %% resize the lower_half image to the enlarged size
    img_lower_r = cat(1, zeros(1, w), img_lower_r);
    img_lower_g = cat(1, zeros(1, w), img_lower_g);
    img_lower_b = cat(1, zeros(1, w), img_lower_b);
    
    
    %% calculate the average by averaging the "neighbors"
    new_value_r = (img_up_r_value + img_mid_r_value + img_low_r_value)/3;
    new_value_g = (img_up_g_value + img_mid_g_value + img_low_g_value)/3;
    new_value_b = (img_up_b_value + img_mid_b_value + img_low_b_value)/3;  
    
    %% the new seam's index

    new_ind = (x_ind-1) * (h+1) + y_ind +1; 
    
    %% getting the new image without the seam by combining the upper and lower half
    new_img_r = img_upper_r + img_lower_r;
    new_img_g = img_upper_g + img_lower_g;
    new_img_b = img_upper_b + img_lower_b;
    
    [vec_new_img_r, vec_new_img_g, vec_new_img_b] = rgb_to_vec_rgb(new_img_r, new_img_g, new_img_b);
    
    %% assign the new seam
    vec_new_img_r(new_ind, 1) = new_value_r;
    vec_new_img_g(new_ind, 1) = new_value_g;
    vec_new_img_b(new_ind, 1) = new_value_b;

    %% change the vectoraized version to proper image dimension
    new_img = vec_rgb_to_img(vec_new_img_r, vec_new_img_g, vec_new_img_b, h+1, w);
    
    
    
    
    
    
    %% doing the same for expand_cost_inf_mask
    mask_upper = expand_cost_inf_mask .* mask;
    mask_lower = expand_cost_inf_mask .* (1 - mask);
        

    %% resize the upper_half image to the enlarged size
    mask_upper = cat(1, mask_upper, zeros(1, w));

    %% resize the lower_half image to the enlarged size
    mask_lower = cat(1, zeros(1, w), mask_lower);

    new_mask = mask_upper + mask_lower;
    
  %  figure, imagesc(new_mask), axis image;
  
    vec_new_mask = img_to_vec_img(new_mask);
  
    new_ind0 = (x_ind-1) * (h+1) + y_ind - 1; 
    new_ind1 = (x_ind-1) * (h+1) + y_ind; 
    new_ind2 = (x_ind-1) * (h+1) + y_ind + 1; 

    new_ind0 = new_ind0(new_ind0 > 0);
    new_ind1 = new_ind1(new_ind1 > 0);
    new_ind2 = new_ind2(new_ind2 > 0);

    vec_new_mask(new_ind0, 1) = 1;    
    vec_new_mask(new_ind1, 1) = 1;    
    vec_new_mask(new_ind2, 1) = 1;
    %{
    inf_y = path(1,end);
    inf_x = w;
    
    new_mask(inf_y, inf_x) = 1;    
    new_mask(inf_y+1, inf_x) = 1;    
%}
    
    new_expand_cost_inf_mask = vec_img_to_img(vec_new_mask, h+1, w);
    
    % figure, imagesc(new_expand_cost_inf_mask), axis image;
end