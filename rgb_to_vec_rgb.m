function [vr, vg, vb] = rgb_to_vec_rgb(r,g,b)
    vr = img_to_vec_img(r);
    vg = img_to_vec_img(g);
    vb = img_to_vec_img(b);
end