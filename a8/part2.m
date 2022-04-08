close all;

URL_prefix = "https://www.cs.unc.edu/~montek/teaching/Comp572-Spring22/hw8/";
images  = [ "camel.jpg"; "cathedral.jpg"; "chapel.jpg"; "courtyard.jpg"; "emir.jpg"; ...
            "gruppa.jpg"; "khan.jpg"; "monastery.jpg"; "nativity.jpg"; "railroad.jpg"; ...
            "settlers.jpg"; "urn.jpg" ];
imagecount = size(images, 1);

for i=1:imagecount
    I=imread(URL_prefix + images(i));
    aligned_I = align_better(I);
    figure; imshow(aligned_I);
end


function aligned = align_better(im)
    % separate the images
    % the cameras were stacked from top to bottom as blue, green, red
    % total image is 1024 long so we divide it up into three parts
    % that is 341.33 so uh lets just floor it and have the bottom get it
    blue_original = imcrop(im, [0 0 width(im) 342]);
    green_original = imcrop(im, [0 341 width(im) 341]);
    red_original = imcrop(im, [0 682 width(im) 341]);

    % time to trim the borders off of the original crops
    % per the instructions, just trimming by 60%
    % the images are 342 by 400 [ got from size(red) ]
    % so width is 240 px and height is 205 px
    % we trim 80 from width on each side and 69 from the height
    % all the numbers are the same now because they are all the same square
    blue = imcrop(blue_original,[80 69 320 273]);
    green = imcrop(green_original,[80 69 320 273]);
    red = imcrop(red_original,[80 69 320 273]);

    % now we do the same part with trimmed sections
    %% EXCEPT for when we shift the image, we use the original
    %% we also use the original when getting the final image color vals

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% SAME AS PART 1 AFTER THIS POINT %%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
    blue_original = imtranslate(blue_original, [row_offset col_offset]);

    % use ncc to align 
    red_green = normxcorr2(red, green);
    
    %find maximum point and use it for offset
    [col_max, row_max] = find(red_green == max(red_green(:)));
    row_offset = row_max - size(green, 2);
    col_offset = col_max - size(green, 1);

    % shift the red to match the green
    red_original = imtranslate(red_original, [row_offset col_offset]);

    aligned(:,:,1) = red_original;
    aligned(:,:,2) = green_original;
    aligned(:,:,3) = blue_original;
    
end

