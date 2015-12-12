function new_img_grad = assign_inf_cost(img_grad, expand_cost_inf_mask)

    [inf_y, inf_x] = find(expand_cost_inf_mask == 1);
    
    
    [h,w,c] = size(img_grad);
    
    vec_img_grad = img_to_vec_img(img_grad);
    ind = (inf_x - 1) * h + inf_y;
    
    vec_img_grad(ind, 1) = Inf;
    
    new_img_grad = vec_img_to_img(vec_img_grad, h, w);
    
    
 %   figure, imagesc(new_img_grad), axis image;
end