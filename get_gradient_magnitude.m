function [Gmag, Gdir] = get_gradient_magnitude(img)
    [Gmag, Gdir] = imgradient(img);
end