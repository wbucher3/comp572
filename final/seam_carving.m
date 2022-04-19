%% Writeups
% * Video URL
% <http://www.xxx.xxx>
%
% * Brief description as per instructions
% 
%
%% Sources to Resources used
% Idea for the heat map was from this lovely site
% https://trekhleb.dev/blog/2021/content-aware-image-resizing-in-javascript/
% research paper from class
% http://graphics.cs.cmu.edu/courses/15-463/2012_fall/hw/proj3-seamcarving/imret.pdf
% video resources
% https://www.mathworks.com/matlabcentral/answers/280635-make-video-from-images

% Image Sources
% https://ithhostels.com/location/san-diego-hostel/
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set up
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% project code, needed for grader
close all;
pretest_flag = 1; % this line of code is designed to pass the pretest.

%% Load Image
im = im2double(imread('https://raw.githubusercontent.com/wbucher3/comp572/main/final/pictures/alley.jpg'));
% im = im2double(imread('https://www.cs.unc.edu/~montek/teaching/Comp790-Spring19/Project/Carving/house_by_jim_mccann.jpg'));
figure; imshow(im);

%% show the heat map
% im_heat_map = energy_map(im);
% figure; imshow(im_heat_map);

%% display the first mask
% mask = column_finder(im_heat_map);
% rgb_im = cat(3, mask, mask, mask);
% figure; imshow(rgb_im);




%% Run whole thing here
     % = main_seam_cutter(image, width % of final image, height % of final image)
new_im = main_seam_cutter(im, 90, 60);
figure; imshow(new_im);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% The Main Function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @ input: image, new width percentage (1 - 99), new height percentage (1 - 99)
% @ output: shrunken image
function final_im = main_seam_cutter(im, width_percentage, height_percentage)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% VIDEO THINGS, REMOVE IN FINAL PROJECT PRESENTATION 
    video = VideoWriter('animation.mp4');
    open(video);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    trimmed_im = im;
    % removes columns
    if width_percentage ~= 0
        trimmed_im = content_aware_remover(im, width_percentage, false, size(im, 2), video);
    end 
    % rotate the image
    if height_percentage ~= 0
        trimmed_im = imrotate(trimmed_im, 90);
        % removes rows of the already removed column image
        trimmed_im = content_aware_remover(trimmed_im, height_percentage, true, size(im,2), video);
        trimmed_im  = imrotate(trimmed_im, 270);

    end 
    %rotate the image back and return it 

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% VIDEO THINGS, REMOVE IN FINAL PROJECT PRESENTATION 
    close(video);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    final_im = trimmed_im;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Main Driver of column remover functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @ input: image, percentage (1 - 99), rotation bool, video object
% @ output: shrunken image
function trimmed_im = content_aware_remover(im, percentage, rotated, original_height, video)

    % get the total number of columns we are trimming off
    total_cols = size(im, 2);
    target_cols = ceil(total_cols * (percentage / 100));
    difference = total_cols - target_cols;
    disp("Removing " + difference + " Columns")

    % trim off the columns one by one
    current_im = im;
    counter = 1;

    for i = 1:difference

        % stuff for console output
        percentage_complete = floor((counter / difference) * 100);
        disp(percentage_complete + "%");
        counter = counter + 1;

        % generate current heat map 
        current_heat_map = energy_map(current_im);

        % find where we should remove the column
        column_mask = column_finder(current_heat_map);

        % used to show the mask for presentation
        % rgb_im = cat(3, column_mask, column_mask, column_mask);
        % figure; imshow(rgb_im);

        % remove that column from the image
        current_im = column_remover(current_im, column_mask);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% VIDEO THINGS, REMOVE IN FINAL PROJECT PRESENTATION 
        % function to add white bars to image to append it to the video 
        white_bar_current_im = white_bar_adder(current_im, total_cols, column_mask, original_height);
        if rotated
            writeVideo(video, imrotate(white_bar_current_im, 270));
        else
            writeVideo(video,white_bar_current_im);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end

    % return the trimmed image
    trimmed_im = current_im;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Video Frame Prepping
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function white_bar_im = white_bar_adder(im, desired_width, mask, desired_height)
        
        masked_im = mask_adder(im, mask);

        %% Adding Black bars on the frame so it fits 
        current_red = masked_im(:,:,1);
        current_green = masked_im(:,:,2);
        current_blue = masked_im(:,:,3);
        % create black bar
        zero_addon = zeros(size(masked_im, 1), desired_width - size(masked_im, 2));

        % add the black bar to the rgb matrices
        zero_r = cat(2,current_red, zero_addon);
        zero_g = cat(2,current_green, zero_addon);
        zero_b = cat(2,current_blue, zero_addon);


        % combine the rgb values back together to return 
        white_bar_im = cat(3, zero_r, zero_g, zero_b);

        if size(white_bar_im, 2) ~= desired_height
            zero_addon = zeros(desired_height - size(white_bar_im,1), size(white_bar_im,2));

            current_red = white_bar_im(:,:,1);
            current_green = white_bar_im(:,:,2);
            current_blue = white_bar_im(:,:,3);

            zero_r = [zero_addon ; current_red];
            zero_g = [zero_addon ; current_green];
            zero_b = [zero_addon ; current_blue];

            white_bar_im = cat(3, zero_r, zero_g, zero_b);

        end 

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Adding Line to Image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function masked_im = mask_adder(im, mask)

    % create empty matrix to append rows to
    final_im_red = zeros(size(im,1), size(im,2));
    final_im_green = zeros(size(im,1), size(im,2));
    final_im_blue = zeros(size(im,1), size(im,2));

    for i = 1:size(im, 1)
        % find where the 1 value is in the mask on the row
        % that is the index where the pixel needs to be removed
        current_mask_row = mask(i,:);
        idx = find(current_mask_row==1);

        current_row_red = im(i,:,1);
        current_row_green = im(i,:,2);
        current_row_blue = im(i,:,3);
        
        % removes the pixel at the index
        current_row_red(idx) = 1;
        current_row_green(idx) = 0;
        current_row_blue(idx) = 0;

        % replace the ith row from final_im_rgb
        final_im_red(i,:) = current_row_red;
        final_im_green(i,:) = current_row_green;
        final_im_blue(i,:) = current_row_blue;

        
    end 
    masked_im = cat(3, final_im_red, final_im_green, final_im_blue);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Energy Function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @ input: image
% @ output: energy matrix/map
% description: basically does edge detection on the image
function map = energy_map(im)
    %map = double(edge(rgb2gray(im), 'sobel'));
    %filter_im = imfilter(rgb2gray(im), fspecial('sobel'));
    %map = filter_im;
    current_map = zeros(size(im,1), size(im, 2));
    for i = 2:(size(im,1) - 1)
        for j = 2:(size(im,2) -1)
            left_red = im(i, j - 1, 1);
            right_red = im(i, j + 1, 1);
            mid_red = im(i, j, 1);

            left_green = im(i, j - 1, 2);
            right_green = im(i, j + 1, 2);
            mid_green = im(i, j, 2);

            left_blue = im(i, j - 1, 3);
            right_blue = im(i, j + 1, 3);
            mid_blue = im(i, j, 3);

            pixel_energy_left = sqrt((left_red-mid_red)^2 + (left_green-mid_green)^2 + (left_blue - mid_blue)^2);
            pixel_energy_right = sqrt((mid_red - right_red)^2 + (mid_green - right_green)^2 + (mid_blue - right_blue)^2);
            pixel_energy_total = pixel_energy_right + pixel_energy_left;
            current_map(i,j) = pixel_energy_total;
        end
    end 
    map = current_map;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Column Finder 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @ input: energy matrix/map
% @ output: 0 matrix with 1's where column to remove
% description: uses shortest path algorithm to find a column that goes through very little edges 

function mask = column_finder(heat_im)
    % this is the start of the dynamic programming matrix to build 
    % starts as the original image
    im_mask = heat_im(1,:);

    % append row by row, with the value being lowest of previous
    for i = 2:size(heat_im, 1)

        current_row = heat_im(i,:);
        new_row = [];
        row_above = i-1;
        
        % for the first number
            possible_values = [im_mask(row_above, 1)  im_mask(row_above, 2)];
            this_value = min(possible_values) + current_row(1);
            new_row = [new_row 99];

        % for the middle
        for j = 2:(size(current_row,2) - 1)
            possible_values = [im_mask(row_above, j-1)  im_mask(row_above, j)  im_mask(row_above, j+1)];
            this_value = min(possible_values) + current_row(j);
            new_row = [new_row this_value];
        end

        % for the end
            possible_values = [im_mask(row_above, size(im_mask,2) - 1)  im_mask(row_above, size(im_mask,2))];
            this_value = min(possible_values) + current_row(size(current_row,2));
            new_row = [new_row 99];

        % appends the new row onto the mask matrix
        im_mask = [im_mask; new_row];

    end

    %% helpful seeing the paths
    % add a debug point or this will show out of control
    % figure; imshow(im_mask);


    % next up! find the smallest value of the bottom row
    % follow that path up to find the column to remove
    
    % get position of min value of bottom row
    bottom_row = im_mask(size(im_mask,1),:);
    [val, idx] = min(bottom_row);

    % matrix of zeros, will fill in 1's where the value is to be removed
    zero_mask = zeros(size(im_mask));
    
    for i = size(im_mask,1):-1:1
        % set the current to pixel value to 1
        zero_mask(i, idx) = 1;
        row_above = i - 1;
    
        % get the next index point

        % only looks for the next pixel if greater than 1
        % if i = 1, we are at the top of the map and this will error
        if i > 1
            % prevents it from trying to find pixel off the right/left edge
            if idx == 1
                possible_values = [99999 im_mask(row_above, idx)  im_mask(row_above, idx+1)];
            elseif idx == size(im_mask,2)
                possible_values = [im_mask(row_above, idx-1)  im_mask(row_above, idx) 99999];
            else
                possible_values = [im_mask(row_above, idx-1)  im_mask(row_above, idx)  im_mask(row_above, idx+1)];
            end

            % check to see if we moving up-left, up-center, or up-right.
            [val, local_idx] = min(possible_values);
    
            if local_idx == 1
                idx = idx - 1;
            elseif local_idx == 3
                idx = idx + 1;
            end 
            
        end 

    end
    
    % finally, return the mask
    % mask is matrix of 1's and 0's where the 1's are to be removed
    mask = zero_mask; 
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Column Remover
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @ input: image, mask of 1's & 0's
% @ output: image - 1 column
% description: removes the one value from each row to remove an entire col
function trimmed_im = column_remover(im, mask)

    % gets matrix the proper size
    shorter_im = im(:,:,1);
    % removes one column (the last column)
    shorter_im(:,size(im,2),:) = [];

    % create empty matrix to append rows to
    final_im_red = zeros(size(shorter_im));
    final_im_green = zeros(size(shorter_im));
    final_im_blue = zeros(size(shorter_im));

    for i = 1:size(im, 1)
        % find where the 1 value is in the mask on the row
        % that is the index where the pixel needs to be removed
        current_mask_row = mask(i,:);
        idx = find(current_mask_row==1);

        current_row_red = im(i,:,1);
        current_row_green = im(i,:,2);
        current_row_blue = im(i,:,3);
        
        % removes the pixel at the index
        current_row_red(idx) = [];
        current_row_green(idx) = [];
        current_row_blue(idx) = [];

        % replace the ith row from final_im_rgb
        final_im_red(i,:) = current_row_red;
        final_im_green(i,:) = current_row_green;
        final_im_blue(i,:) = current_row_blue;

        
    end 
    trimmed_im = cat(3, final_im_red, final_im_green, final_im_blue);

end