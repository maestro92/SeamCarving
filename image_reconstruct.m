function im_out = image_reconstruct(img, img_dy, img_dx, channel)
    
    img = img(:,:,channel);
    img_dy = img_dy(:,:,channel);
    img_dx = img_dx(:,:,channel);

    [img_h, img_w, c] = size(img);
    im2var = zeros(img_h, img_w);
    im2var(1:img_h*img_w) = 1:img_h*img_w;
    
    s = img;
    %{
        v: n by 1   n: is the number of variables
        A: m by n   m: number of equations
        b: m by 1
    
        a variable per pixel
        equations per pair pixels
    %}
    
    n = img_h * img_w
    
    %{
        number of pairs that has horizontal constraints
        img_h * (img_w-1)
    
        number of pairs that has vertical constraints
        (img_h-1) * img_w
    %}
    m = img_h * (img_w-1) + (img_h-1) * img_w + 1;
    e = 0;
    
    %A = zeros(m, n);
  %  A = sparse(m, n);
    A = spalloc(m,n, 2*m);
    b = zeros(m, 1);

    
    %{
    mid_xs = [1:img_w-1];
    mid_ys = [1:img_h-1];
    
    mid_indices = (mid_xs-1) * img_h + img_w;
    e_indices = 1:e;
    %}
    
    
    for y = 1:img_h
        y
        for x = 1:img_w
             
            %  x
            if x ~= img_w
                e = e + 1;
                A(e, im2var(y, x+1)) = 1;
                A(e, im2var(y, x)) = -1;
            %    b(e) = s(y,x+1) - s(y,x);
                b(e) = img_dx(y,x);
            end
            
            if y ~= img_h                
                e = e + 1;
                A(e, im2var(y+1, x)) = 1;
                A(e, im2var(y, x)) = -1;
            %    b(e) = s(y+1,x) - s(y,x);   
                b(e) = img_dy(y,x);    
            end
        end
    end
    
    
    
    e = e + 1;
    A(e, im2var(1,1)) = 1;
    b(e) = s(1,1);

    
    sparse_A = sparse(A);
    flag = issparse(sparse_A);
     
    v = sparse_A\b;
    im_out = reshape(v, [img_h img_w]);
    
    figure, imagesc(im_out); axis image; colormap gray;
    
    
end


%{
function im_out = image_reconstruct(img)
    
    [img_h, img_w, c] = size(img);
    im2var = zeros(img_h, img_w);
    im2var(1:img_h*img_w) = 1:img_h*img_w;
    
    s = img;
    %{
        v: n by 1   n: is the number of variables
        A: m by n   m: number of equations
        b: m by 1
    
        a variable per pixel
        equations per pair pixels
    %}
    
    n = img_h * img_w
    
    %{
        number of pairs that has horizontal constraints
        img_h * (img_w-1)
    
        number of pairs that has vertical constraints
        (img_h-1) * img_w
    %}
    m = img_h * (img_w-1) + (img_h-1) * img_w + 1;
    e = 0;
    
    A = zeros(m, n);
    b = zeros(m, 1);
    
    for y = 1:img_h
        for x = 1:img_w
            if x ~= img_w
                e = e + 1;
                A(e, im2var(y, x+1)) = 1;
                A(e, im2var(y, x)) = -1;
                b(e) = s(y,x+1) - s(y,x);
            end
            
            if y ~= img_h                
                e = e + 1;
                A(e, im2var(y+1, x)) = 1;
                A(e, im2var(y, x)) = -1;
                b(e) = s(y+1,x) - s(y,x);            
            end
        end
    end
    
    e = e + 1;
    A(e, im2var(1,1)) = 1;
    b(e) = s(1,1);

    
    sparse_A = sparse(A);
    flag = issparse(sparse_A);
     
    v = sparse_A\b;
    im_out = reshape(v, [img_h img_w]);
    
    figure, imagesc(im_out); axis image; colormap gray;
    
    
end
%}
