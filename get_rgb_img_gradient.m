function [img_grad, img_r, img_g, img_b] = get_rgb_img_gradient(img)
    %{
    [img_r, img_g, img_b] = get_img_rgb(img);
    [img_r_grad, img_dir] = get_gradient_magnitude(img_r);
    [img_g_grad, img_dir] = get_gradient_magnitude(img_g);
    [img_b_grad, img_dir] = get_gradient_magnitude(img_b);
    
    img_grad = sqrt(img_r_grad.*img_r_grad + img_g_grad.*img_g_grad + img_b_grad.*img_b_grad);
%}
    [img_r, img_g, img_b] = get_img_rgb(img);
    img_gray = rgb2gray(img);
    img_grad = get_gradient_magnitude(img_gray);

end
