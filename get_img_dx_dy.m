function [img_dy, img_dx] = get_img_dx_dy(img)
    
    [img_r, img_g, img_b] = get_img_rgb(img);
    
    dx_filter = [0 -1 1];
    dy_filter = [0; -1; 1];
    
    
    img_dy_r = imfilter(img_r, dy_filter); 
    img_dy_g = imfilter(img_g, dy_filter); 
    img_dy_b = imfilter(img_b, dy_filter); 
    
    img_dx_r = imfilter(img_r, dx_filter); 
    img_dx_g = imfilter(img_g, dx_filter); 
    img_dx_b = imfilter(img_b, dx_filter); 
    
    
    img_dy = zeros(size(img));
    img_dy(:,:,1) = img_dy_r;
    img_dy(:,:,2) = img_dy_g;
    img_dy(:,:,3) = img_dy_b;

    img_dx(:,:,1) = img_dx_r;
    img_dx(:,:,2) = img_dx_g;
    img_dx(:,:,3) = img_dx_b;

    %{
    [img_h, img_w ,c] = size(img);
    dx_r = zeros(img_h, img_w);
    
    for y = 1:img_h
        for x = 1:img_w
            
        %    y
        %    x
            if x ~= img_w
                dx_r(y,x) = img_r(y,x+1) - img_r(y,x);
                
           %{
                e = e + 1;
                A(e, im2var(y, x+1)) = 1;
                A(e, im2var(y, x)) = -1;
                b(e) = s(y,x+1) - s(y,x);
  %}
            end
            
     %       if y ~= img_h                
     %           dx_r(y,x) = img_r(y+1,x) - img_r(y,x);
                
       %{
                e = e + 1;
                A(e, im2var(y+1, x)) = 1;
                A(e, im2var(y, x)) = -1;
                b(e) = s(y+1,x) - s(y,x);            
      %}
     %       end
        end
    end
    %}
end