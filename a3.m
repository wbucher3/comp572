%% QUESTION 1 GREY SCALE 
function img_gray = method1(im)
    img_gray = rgb2gray(im);
end

function img_gray = method2(im)
    red = im(:, :, 1);
    green = im(:, :, 2);
    blue = im(:, :, 3);
    avg =  (red + green + blue) ./3;
    img_gray = avg; 
end

function img_gray = method3(im)
    red = im(:, :, 1);
    green = im(:, :, 2);
    blue = im(:, :, 3);
    sum =  (red .* .3) + (green .* .59) + (blue .* 0.11);
    img_gray = sum;
end

function img_gray = method4(im)
   hsvIm = rgb2hsv(im);
   hue = hsvIm(:, :, 1);
   sat = hsvIm(:, :, 2) .* 0;
   value = hsvIm(:, :, 3);
   
   img_gray = hsv2rgb(cat(3, hue, sat, value));
end




%% QUESTION 2 - Sepia

function output = sepia(im)

    red = im(:, :, 1);
    green = im(:, :, 2);
    blue = im(:, :, 3);
    
    sepia_r = (red .* 0.393) + (green .* 0.769) + (blue .* 0.189);
    sepia_g = (red .* 0.349) + (green .* 0.686) + (blue .* 0.168);
    sepia_b = (red .* 0.272) + (green .* 0.534) + (blue .* 0.131);
    
    output = cat(3, sepia_r, sepia_g, sepia_b);
end



%% QUESTION 3 - white balance 

function im_balanced = color_balance(im)
    red = im(:, :, 1);
    green = im(:, :, 2);
    blue = im(:, :, 3);
    
    red_avg = mean2(red);
    green_avg = mean2(green);
    blue_avg = mean2(blue);
    
    total_avg = (red_avg + green_avg + blue_avg) / 3;
    
    red_bal = red .* (total_avg / red_avg);
    green_bal = green .* (total_avg / green_avg);
    blue_bal =  blue .* (total_avg / blue_avg);
    
    im_balanced = cat(3, red_bal, green_bal, blue_bal);
    
    
end


%% QUESTION 4 - contrast 

function [im_contrast, black_point, white_point] = contrast_method1(im, low_thresh_prctile, high_thresh_prctile)
    bw_im = rgb2gray(im);  % convert to intensity-only image to compute back and white points
    black_point = prctile(bw_im, low_thresh_prctile, 'all') % compute and return the black point value
    white_point = prctile(bw_im, high_thresh_prctile, 'all')  % compute and return the white point value
    %% Note:  the black and white point values are also returned for checking (pre-test)
    im_contrast = imadjust(im, [black_point white_point], []); % compute and return the adjusted color image
end

function im_contrast = contrast_method2(im)
    im_contrast = histeq(im);
end


%% QUESTION 5 - crop in half 

function im_half = im_halfsize(im)
    [rows, cols, colors] = size(im);
    starting_height =  1 + floor(rows/4);
    starting_width =  1 + floor(cols/4);
    cropped_height = floor(rows/2);
    cropped_width = floor(cols/2);
    
    cropped_img = im(starting_height:(starting_height + cropped_height - 1), starting_width:(starting_width + cropped_width - 1), :);
    im_half = cropped_img;
end




function sharper = sharpen(im)
    filterMatrix = [0 -1 0 ; -1 5 -1 ; 0 -1 0];
    sharper = imfilter(im, filterMatrix);
end



%% Filter effect description
%{

Describe the filter's effects in 2-3 lines (plain English!).
This is how you should start this exercise, by writing down
what effect you are trying to achieve, before writing any code!

The goal of this filter was to make people look 
like they were on money! \
To do this, I wanted the images to be close to black and white, but have a slight hue 
of green to them. So using the rgb values, i zero'd out
the red and blue values and left the green alone. 
I then converted the image into an hsv format to lower the saturation of green
and raise the value of the image so it wasnt super dark. 

%}


% Specify your chosen images in the imread() commands below.
% Please read the detailed note at the top of the homework description
% if you want to use an image file uploaded and shared from Google Drive.

%%IMPORTANT NOTE regarding picture size and server timeouts:
%% PLEASE EITHER use picture sizes of around 1 or 2 megapixels
%% (any larger is typically wasted on our limited screen sizes!)
%% AND/OR
%% comment out the "set(gcf, ...);" lines which try to display
%% the results in high resolution, which can be problematic for
%% hi-res images.


im=imread('https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Gilbert_Stuart_Williamstown_Portrait_of_George_Washington.jpg/1687px-Gilbert_Stuart_Williamstown_Portrait_of_George_Washington.jpg');
filtered = myFilter(im);
% display code
imsize=size(im);
figure(1); montage({im, filtered}, 'Size', [1 2]);
%set(gcf,'Position',[0, 0, imsize(2)*2, imsize(1)]);

im=imread('https://raw.githubusercontent.com/wbucher3/comp572/main/pictures/DennyAndMe.jpg');
filtered = myFilter(im);
% display code
imsize=size(im);
figure(2); montage({im, filtered}, 'Size', [1 2]);
%set(gcf,'Position',[0, 0, imsize(2)*2, imsize(1)]);

im=imread('https://raw.githubusercontent.com/wbucher3/comp572/main/pictures/hesNotCup.jpg');
filtered = myFilter(im);
% display code
imsize=size(im);
figure(3); montage({im, filtered}, 'Size', [1 2]);
%set(gcf,'Position',[0, 0, imsize(2)*2, imsize(1)]);


function result = myFilter(im)
    % make the image only green
    red = im(:, :, 1) .* 0;
    green = im(:, :, 2);
    blue = im(:, :, 3) .* 0;   
    full_green_im = cat(3, red, green, blue);
    
    % transfer into hsv to turn up the value and turn down the saturation
    hsv_green_im = rgb2hsv(full_green_im);
    hue = hsv_green_im(:, :, 1);
    sat = hsv_green_im(:, :, 2) .* .2;
    value = hsv_green_im(:, :, 3) .* 1.5;
    hsv_lightgreen_im = cat(3, hue, sat, value);
    
    result = hsv2rgb(hsv_lightgreen_im);

end











%% Filter effect description
%{

Describe the filter's effects in 2-3 lines (plain English!).
This is how you should start this exercise, by writing down
what effect you are trying to achieve, before writing any code!

The goal of this filter was to make it look like an old west photo

%}


% Specify your chosen images in the imread() commands below.
% Please read the detailed note at the top of the homework description
% if you want to use an image file uploaded and shared from Google Drive.

%%IMPORTANT NOTE regarding picture size and server timeouts:
%% PLEASE EITHER use picture sizes of around 1 or 2 megapixels
%% (any larger is typically wasted on our limited screen sizes!)
%% AND/OR
%% comment out the "set(gcf, ...);" lines which try to display
%% the results in high resolution, which can be problematic for
%% hi-res images.


im=imread('https://raw.githubusercontent.com/wbucher3/comp572/main/pictures/Denver.jpg');
filtered = myFilter(im);
% display code
imsize=size(im);
figure(1); montage({im, filtered}, 'Size', [1 2]);
%set(gcf,'Position',[0, 0, imsize(2)*2, imsize(1)]);

im=imread('https://raw.githubusercontent.com/wbucher3/comp572/main/pictures/DennyAndMe.jpg');
filtered = myFilter(im);
% display code
imsize=size(im);
figure(2); montage({im, filtered}, 'Size', [1 2]);
%set(gcf,'Position',[0, 0, imsize(2)*2, imsize(1)]);

im=imread('https://raw.githubusercontent.com/wbucher3/comp572/main/pictures/hesNotCup.jpg');
filtered = myFilter(im);
% display code
imsize=size(im);
figure(3); montage({im, filtered}, 'Size', [1 2]);
%set(gcf,'Position',[0, 0, imsize(2)*2, imsize(1)]);


function result = myFilter(im)
    im = im2double(im);
    % Code to make the image sepia, taken from my a3 question 2
    red = im(:, :, 1);
    green = im(:, :, 2);
    blue = im(:, :, 3);
    
    sepia_r = (red .* 0.393) + (green .* 0.769) + (blue .* 0.189);
    sepia_g = (red .* 0.349) + (green .* 0.686) + (blue .* 0.168);
    sepia_b = (red .* 0.272) + (green .* 0.534) + (blue .* 0.131);
    
    im_sepia = cat(3, sepia_r, sepia_g, sepia_b);
    [row, columns, colors] = size(im_sepia);
    % add a vinette
    spread = row / 3.8;
    myGauss = fspecial('gaussian', [row columns], spread);
    vignette = myGauss ./ max(myGauss(:));
    result = im_sepia .* vignette;

end
