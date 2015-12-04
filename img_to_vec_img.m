function vec_img = img_to_vec_img(I)
    [h,w] = size(I);
    vec_img = reshape(I, [h*w], 1);
end