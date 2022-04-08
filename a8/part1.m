close all;

URL_prefix = "https://www.cs.unc.edu/~montek/teaching/Comp572-Spring22/hw8/";
images  = [ "camel.jpg"; "cathedral.jpg"; "chapel.jpg"; "courtyard.jpg"; "emir.jpg"; ...
            "gruppa.jpg"; "khan.jpg"; "monastery.jpg"; "nativity.jpg"; "railroad.jpg"; ...
            "settlers.jpg"; "urn.jpg" ];
imagecount = size(images, 1);
for i=1:imagecount
    I=imread(URL_prefix + images(i));
    aligned_I = align_basic(I);
    figure; imshow(aligned_I);
end


function aligned = align_basic(im)
    % separate the images
    % the cameras were stacked from top to bottom as blue, green, red
    % total image is 1024 long so we divide it up into three parts
    % that is 341.33 so uh lets just floor it and have the bottom get it
    blue = imcrop(im, [0 0 width(im) 342]);
    green = imcrop(im, [0 341 width(im) 341]);
    red = imcrop(im, [0 682 width(im) 341]);

    % i am choosing to align around green since it's in the center 
    % hopefully this will provide the best results
    
    % use ncc to align 
    blue_green = normxcorr2(blue, green);
    
    %find maximum point and use it for offset
    % it's height width so y,x weird
    [col_max, row_max] = find(blue_green == max(blue_green(:)));
    row_offset = row_max - size(green, 2);
    col_offset = col_max - size(green, 1);

    % shift the blue to match the green
    blue = imtranslate(blue, [row_offset col_offset]);

    % use ncc to align 
    red_green = normxcorr2(red, green);
    
    %find maximum point and use it for offset
    [col_max, row_max] = find(red_green == max(red_green(:)));
    row_offset = row_max - size(green, 2);
    col_offset = col_max - size(green, 1);

    % shift the red to match the green
    red = imtranslate(red, [row_offset col_offset]);

    aligned(:,:,1) = red;
    aligned(:,:,2) = green;
    aligned(:,:,3) = blue;
    
    
end

