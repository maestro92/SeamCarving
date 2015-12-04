function [r,g,b] = get_img_rgb(img)
    r = img(:,:,1);
    g = img(:,:,2);
    b = img(:,:,3);
end