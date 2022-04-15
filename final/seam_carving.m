%% Writeups
% * Video URL
% <http://www.xxx.xxx>
%
% * Brief description as per instructions
% 
%
% Sources to Resources used
% https://trekhleb.dev/blog/2021/content-aware-image-resizing-in-javascript/
% http://graphics.cs.cmu.edu/courses/15-463/2012_fall/hw/proj3-seamcarving/imret.pdf

% Image Sources
% shark image
% https://howchoo.com/drones/drone-footage-of-sharks-with-swimmers


%% Your project code
close all;
pretest_flag = 1; % this line of code is designed to pass the pretest.

%% Runner Code
% load in test image
im = im2double(imread('https://raw.githubusercontent.com/wbucher3/comp572/main/pictures/balloon.jpg'));
figure; imshow(im);


%im_heat_map = energy_map(im);
%figure; imshow(im_heat_map);


%mask = column_finder(im_heat_map);
% mask to rgb
%rgb_im = cat(3, mask, zeros(size(mask)), zeros(size(mask)));
%figure; imshow(rgb_im);

new_im = content_aware_remover(im, 80);
figure; imshow(new_im);
% get energy map 

%% Black Box Content Aware column remover function
% @ input: image, percentage (1 - 99)
% @ output: shrunken image
function trimmed_im = content_aware_remover(im, percentage)
    % get the total number of columns we are trimming off
    total_cols = size(im, 2)
    target_cols = ceil(total_cols * (percentage / 100))
    difference = total_cols - target_cols;
    % trim off the columns one by one
    current_im = im;
    counter = 0;
    for i = 1:difference
        disp(counter)
        counter = counter + 1;
        % generate current heat map 
        current_heat_map = energy_map(current_im);

        % find where we should remove the column
        column_mask = column_finder(current_heat_map);

        % remove that column from the image
        current_im = column_remover(current_im, column_mask);
    end

    % return the trimmed image
    trimmed_im = current_im;
end


%% Energy Function
% @ input: image
% @ output: energy matrix/map
% description: basically does edge detection on the image
function map = energy_map(im)
    %map = double(edge(rgb2gray(im), 'sobel'));
    filter_im = imfilter(rgb2gray(im), fspecial('sobel'));
    map = filter_im ;
end

%% Column Finder 
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
            new_row = [new_row this_value];

        % for the middle
        for j = 2:(size(current_row,2) -1)
            possible_values = [im_mask(row_above, j-1)  im_mask(row_above, j)  im_mask(row_above, j+1)];
            this_value = min(possible_values) + current_row(j);
            new_row = [new_row this_value];
        end

        % for the end
            possible_values = [im_mask(row_above, size(im_mask,2) - 1)  im_mask(row_above, size(im_mask,2))];
            this_value = min(possible_values) + current_row(size(current_row,2));
            new_row = [new_row this_value];

        % appends the new row onto the mask matrix
        im_mask = [im_mask; new_row];

    end

    % find the smallest value of the bottom row
    % follow that path up to find the column to remove
    
    % get position of min value of bottom row
    bottom_row = im_mask(size(im_mask,1),:);
    [val, idx] = max(bottom_row);

    zero_mask = zeros(size(im_mask));
    
    for i = size(im_mask,1):-1:1
        % set the current to white pixel
        zero_mask(i, idx) = 1;
        row_above = i - 1;
    
        % get the next index point\

        % first if is for when it hits the top, tells it is done
        if i > 1
            % prevents it from trying to find pixel off the right/left edge
            if idx == 1
                possible_values = [-99999 im_mask(row_above, idx)  im_mask(row_above, idx+1)];
            elseif idx == size(im_mask,2)
                possible_values = [im_mask(row_above, idx-1)  im_mask(row_above, idx) -99999];
            else
                possible_values = [im_mask(row_above, idx-1)  im_mask(row_above, idx)  im_mask(row_above, idx+1)];
            end

            [val, small_idx] = max(possible_values);
    
            if small_idx == 1
                idx = idx - 1;
            elseif small_idx == 3
                idx = idx + 1;
            end 
            
        end 

    end
    
    
    
    mask = zero_mask; 
end

%% Column Remover
% @ input: image, column info to be removed
% @ output: image - 1 column
% description: removes the one value from each row to remove an entire col
function trimmed_im = column_remover(im, mask)
%     im(:,1, :) = []; % test code that removes the first column
%     trimmed_im = im;

    final_im_red = [];
    final_im_green = [];
    final_im_blue = [];
    for i = 1:size(im, 1)
        % find where the 1 is in the mask on the row
        mask_row = mask(i,:);
        idx = find(mask_row==1);
        im_row_red = im(i,:,1);
        im_row_green = im(i,:,2);
        im_row_blue = im(i,:,3);
        
        im_row_red(idx) = [];
        im_row_green(idx) = [];
        im_row_blue(idx) = [];

        final_im_red = [final_im_red ; im_row_red];
        final_im_green = [final_im_green ; im_row_green];
        final_im_blue = [final_im_blue ; im_row_blue];

        
    end 
    trimmed_im = cat(3, final_im_red, final_im_green, final_im_blue);

end