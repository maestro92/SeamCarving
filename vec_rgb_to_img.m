function img = vec_rgb_to_img(vr, vg, vb, h, w)
    
    r = reshape(vr, [h,w]);
    g = reshape(vg, [h,w]);
    b = reshape(vb, [h,w]);

    img = cat(3, r,g);
    img = cat(3, img, b);
end