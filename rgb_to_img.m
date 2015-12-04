function img = rgb_to_img(r,g,b)
    img = cat(3, r, g);
    img = cat(3, img, b);
end