close all;

URL_prefix = "https://www.cs.unc.edu/~montek/teaching/Comp572-Spring22/hw8/";
images  = [ "chapel.jpg"; "cathedral.jpg"; "camel.jpg"; "courtyard.jpg"; "emir.jpg"; ...
            "gruppa.jpg"; "khan.jpg"; "monastery.jpg"; "nativity.jpg"; "railroad.jpg"; ...
            "settlers.jpg"; "urn.jpg" ];
imagecount = size(images, 1);

for i=1:imagecount
    I=imread(URL_prefix + images(i));
    aligned_I = align_final(I);
    figure; imshow(I);
    figure; imshow(align_better(I));
    figure; imshow(aligned_I)
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


function aligned = align_final(im)
    colored_im = align_better(im);
    colored_im = im2double(colored_im);
    im_double = im2double(im);
   
    %Plan for trimming!
    %if the average of the row/col matches in a range from mean +/- std, cut it
    % get mean & std from og pic since it's already in b&w
    
    avg_all = mean(im_double, 'all');
    std_all = std(im_double, 0, 'all');
    low_threshold = avg_all - std_all;
    high_threshold = avg_all + std_all;

    red_avg_col = mean(colored_im(:,:,1));
    green_avg_col = mean(colored_im(:,:,2));
    blue_avg_col = mean(colored_im(:,:,3));

    red_avg_row = mean(colored_im(:,:,1),2);
    green_avg_row = mean(colored_im(:,:,2),2);
    blue_avg_row = mean(colored_im(:,:,3),2);
        

    %rows
    % creates a mask for each color
    for i = 1:size(colored_im, 1)
    %%%%%% RED MASK %%%%%%%
        if red_avg_row(i) > high_threshold || red_avg_row(i) < low_threshold
            red_avg_row(i) = 0;
        else
            red_avg_row(i) = 1;
        end     
    %%%%%% GREEN MASK %%%%%%%
        if green_avg_row(i) > high_threshold || green_avg_row(i) < low_threshold
            green_avg_row(i) = 0;
        else
            green_avg_row(i) = 1;
        end     
    %%%%%% BLUE MASK %%%%%%%
        if blue_avg_row(i) > high_threshold || blue_avg_row(i) < low_threshold
            blue_avg_row(i) = 0;
        else
            blue_avg_row(i) = 1;
        end   

    end

    %cols
    for i = 1:size(colored_im, 2)
    %%%%%% RED MASK %%%%%%%
        if red_avg_col(i) > high_threshold || red_avg_col(i) < low_threshold
            red_avg_col(i) = 0;
        else 
            red_avg_col(i) = 1;
        end     
    %%%%%% GREEN MASK %%%%%%%
        if green_avg_col(i) > high_threshold || green_avg_col(i) < low_threshold
            green_avg_col(i) = 0;
        else 
            green_avg_col(i) = 1;
        end   
    %%%%%% BLUE MASK %%%%%%%
        if blue_avg_col(i) > high_threshold || blue_avg_col(i) < low_threshold
            blue_avg_col(i) = 0;
        else 
            blue_avg_col(i) = 1;
        end  
    end   

    
    %%%%%% add up all the masks so we have two (row and col masks)
    % rows
    row_mask = red_avg_row;
    for i = 1:size(colored_im, 1)
        if red_avg_row(i) == 0 || blue_avg_row(i) == 0 || green_avg_row(i) == 0 
            row_mask(i) = 0;
        else 
            row_mask(i) = 1;
        end
    end
    
    % cols
    col_mask = red_avg_col;
    for i = 1:size(colored_im, 2)
        if red_avg_col(i) == 0 || blue_avg_col(i) == 0 || green_avg_col(i) == 0 
            col_mask(i) = 0;
        else 
            col_mask(i) = 1;
        end
    end

    % iterate through the masks to find the new starting and ending points
    % these points will be used for imcrop
    row_starting_point = 0;
    row_ending_point = 0;
    col_starting_point = 0; 
    col_ending_point = 0;
   
    % flips are used to find the end points
    flipped_row_mask = flip(row_mask);
    flipped_col_mask = flip(col_mask);

    % row beginning
    for i = 1:size(row_mask,1)
        if row_mask(i) == 1
            row_starting_point = i;
            break
        end
    end
    % row end
    for i = 1:size(row_mask,1)
        if flipped_row_mask(i) == 1
            row_ending_point = i;
            break
        end
    end

    % col beginning
    for i = 1:size(col_mask,2)
        if col_mask(i) == 1
            col_starting_point = i;
            break
        end
    end
    % col end
    for i = 1:size(col_mask,2)
        if flipped_col_mask(i) == 1
            col_ending_point = i;
            break
        end

    end

    % this way counted how many pixels in so now we have to find where is
    row_ending_point = size(colored_im, 1) - row_ending_point;
    col_ending_point = size(colored_im, 2) - col_ending_point;

    % finally trim the image using our new end points
    aligned = imcrop(colored_im,[row_starting_point col_starting_point row_ending_point col_ending_point]);
   

    
end

