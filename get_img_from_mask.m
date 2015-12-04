function out_img = get_img_from_mask(img, mask)

    img_r = img(:,:,1) .* mask;
    img_g = img(:,:,2) .* mask;
    img_b = img(:,:,3) .* mask;

    out_img = rgb_to_img(img_r, img_g, img_b);
end