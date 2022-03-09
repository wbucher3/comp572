close('all');   % close all open figures so we start with a clean slate!

im_bg = im2double(imread('swim.jpg'));        % background image
im_obj = im2double(imread('bear.jpg'));       % source image

% Get source region mask (extracted object) from the user
% First draw a polygon on the source image for applying the mask

% [poly_x, poly_y] = getPolygonForMask(im_obj);

% NOTE: For your own image sets, simply uncomment the call to getPolygonForMask(), and
% DO NOT USE the hard-coded polygon coordinates below!
poly_x = [276.4628  324.9961  391.5884  425.4488  453.6659  457.0519  433.3496 442.3791 ...
    441.2504  348.6984  248.2457  222.2860  238.0876  226.8008  222.2860  214.3853  224.5434  248.2457];
poly_y = [255.3512  238.4209  255.3512  250.8364  260.9946  283.5682  329.8442  349.0318 ...
    404.3372  419.0101  404.3372  356.9326  342.2597  308.3992  292.5977  265.5093  250.8364  247.4504];

% Convert polygon to a binary mask
objmask = poly2mask(poly_x, poly_y, size(im_obj, 1), size(im_obj, 2));

% Next, align the source object (im_s) and mask (mask_s) with the background image.
% Get the bottom center location on the target image by using the function
% getBottomCenterLoc interactively

% [center_x, bottom_y] = getBottomCenterLoc(im_bg);

% NOTE: For your own image sets, simply uncomment the call to getBottomCenterLoc(), and
% DO NOT USE the hard-coded alignment coordinates below!
center_x = 575.9264;
bottom_y = 432.4922;

% Translate both the source image and the object mask for proper alignment
% w.r.t. the background image
% Pad the extracted object by 64 pixels each side to allow for feathering/blending overlap.

padding = 64;
[im_s, mask_s] = alignSource(im_obj, objmask, im_bg, center_x, bottom_y, padding);
mask_s = im2double(mask_s);  % convert mask from binary to double

% Call the function to blend the images using the mask
result1 = cut_and_paste(im_bg, im_s, mask_s);

% Display:  target image, source image, mask, then blended result
figure; montage({im_bg, im_obj, mask_s, result1});


%%
% -------------------------------------------------------------------------
% IMPORTANT NOTE (please read carefully)
% -------------------------------------------------------------------------
% Repeat your method for 4 more sets of images.  But remember that for
% these you must interactively specify the mask and alignment ONE TIME.
%
% The Matlab Grader website does not allow interactive code.  Therefore,
% you must first develop and run your code either in the Matlab computer
% app, or in the full Matlab Online version (https://matlab.mathworks.com).
% Both of those version allow interactive code, which will allow you to
% specify a mask for object selection and an alignment point in the
% target/background image.
%
% Once you are satisfied with your choice of mask and alignment, copy the
% values of the poly_x and poly_y vectors (which define the vertices of the
% polygon mask), and the values of center_x and bottom_y (which specify the
% alignment) from the output of the Command Window.  Then, hard-code these
% values into your code below, just like it was done for the first image
% set above.
%
% There are two reasons for hard-coding these values.  First, it avoids the
% need to repeatedly interact with the tool to specify the mask and
% alignment while you are fine tuning the blending algorithm.  Second, you
% will be submitting your final work on the Matlab Grader website which
% does not allow interactive code.
%
% -------------------------------------------------------------------------


%%%%% your own images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
im_bg = im2double(imread('https://raw.githubusercontent.com/wbucher3/comp572/main/pictures/orange.jpg'));        % background image
im_obj = im2double(imread('https://raw.githubusercontent.com/wbucher3/comp572/main/pictures/apple.jpg'));       % source image

im_obj = imresize(im_obj, 1.45);
% % Get source region mask (extracted object) from the user
% %  First draw a polygon on the source image for applying the mask

%[poly_x, poly_y] = getPolygonForMask(im_obj);
disp("Copy the values of the vectors poly_x and poly_y from the " + ...
    "Command Window below and hard code them inside your code for " + ...
    "submission via the Grader website.");
%poly_x        % display x coords of polygon
%poly_y        % display y coords of polygon
% Once you have these coordinates, comment out the call to getPolygonForMask()
% and hard code the coordinates instead.
poly_x = [300.9722  316.2504  395.6973  442.5506  482.2740  504.6821  497.5523  452.7361  377.3634  299.9536];
poly_y = [145.6433  530.6551  520.4696  476.6720  416.5776  338.1492  256.6653  183.3297  147.6804  145.6433];
objmask = poly2mask(poly_x, poly_y, size(im_obj, 1), size(im_obj, 2));

% % Get the bottom center location on the target image by using the function
% % getBottomCenterLoc interactively

%[center_x, bottom_y] = getBottomCenterLoc(im_bg);
disp("Copy the values of center_x and bottom_y from the " + ...
    "Command Window below and hard code them inside your code for " + ...
    "submission via the Grader website.");
center_x = 450;    % display x coord where center of object should be placed
bottom_y = 510;       % display y coord where bottom of object should be placed
% Once you have these coordinates, comment out the call to getBottomCenterLoc()
% and hard code the coordinates instead.
padding = 64;   % You may want to play with this parameter
[im_s, mask_s] = alignSource(im_obj, objmask, im_bg, center_x, bottom_y, padding);
mask_s = im2double(mask_s);
% % Apply your blending method
result2 = cut_and_paste(im_bg, im_s, mask_s);
% Display:  target image, source image, mask, then blended result
figure; montage({im_bg, im_obj, mask_s, result2});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% REPEAT ABOVE FOR IMAGE SET 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
im_bg = im2double(imread('https://raw.githubusercontent.com/wbucher3/comp572/main/pictures/Denver.jpg'));  % background image
im_obj = im2double(imread('https://raw.githubusercontent.com/wbucher3/comp572/main/pictures/eyeball.jpg'));       % source image

im_obj = imresize(im_obj, 0.6);

poly_x = [55.5828   69.6465  105.3917  168.0924  227.2771  263.6083  292.9076  311.0732  306.3854  269.4682  215.5573  147.5828   95.4299   71.9904   56.1688];
poly_y = [182.4490  121.5064   79.9013   54.7038   61.7357   79.3153  114.4745  164.8694  228.7420  276.2070  307.8503  308.4363  276.7930  247.4936  182.4490];
objmask = poly2mask(poly_x, poly_y, size(im_obj, 1), size(im_obj, 2));

center_x = 1200;    % display x coord where center of object should be placed
bottom_y = 1250;       % display y coord where bottom of object should be placed
padding = 64;   % You may want to play with this parameter
[im_s, mask_s] = alignSource(im_obj, objmask, im_bg, center_x, bottom_y, padding);
mask_s = im2double(mask_s);
% % Apply your blending method
result2 = cut_and_paste(im_bg, im_s, mask_s);
% Display:  target image, source image, mask, then blended result
figure; montage({im_bg, im_obj, mask_s, result2});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





% REPEAT ABOVE FOR IMAGE SET 4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
im_bg = im2double(imread('https://raw.githubusercontent.com/wbucher3/comp572/main/pictures/friends.jpg'));  % background image
im_obj = im2double(imread('https://raw.githubusercontent.com/wbucher3/comp572/main/pictures/discoball.jpg'));       % source image

im_obj = imresize(im_obj, 1.8);

poly_x = [495.6943  348.5701  257.2516  213.2834  216.6656  269.0892  365.4809  473.7102  622.5255  744.2834  811.9268  833.9108  808.5446  747.6656  629.2898  494.0032];
poly_y = [256.6990  310.8137  400.4411  515.4347  605.0621  723.4379  821.5207  872.2532  863.7978  780.9347  681.1608  578.0048  446.1003  353.0908  287.1385  256.6990];
objmask = poly2mask(poly_x, poly_y, size(im_obj, 1), size(im_obj, 2));

center_x = 1450;    % display x coord where center of object should be placed
bottom_y = 750;       % display y coord where bottom of object should be placed

padding = 64;   % You may want to play with this parameter
[im_s, mask_s] = alignSource(im_obj, objmask, im_bg, center_x, bottom_y, padding);
mask_s = im2double(mask_s);
% % Apply your blending method
result2 = cut_and_paste(im_bg, im_s, mask_s);
% Display:  target image, source image, mask, then blended result
figure; montage({im_bg, im_obj, mask_s, result2});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





% REPEAT ABOVE FOR IMAGE SET 5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
im_bg = im2double(imread('https://raw.githubusercontent.com/wbucher3/comp572/main/pictures/hesNotCup.jpg'));  % background image
im_obj = im2double(imread('https://raw.githubusercontent.com/wbucher3/comp572/main/pictures/cokeCan.jpg'));       % source image

im_obj = imresize(im_obj, 1.3);

poly_x = [235.2452  138.1592  112.8010  114.9745  140.3328  146.1290  229.4490  315.6672  335.9538  344.6481  320.0143  236.6943];
poly_y = [5.2094   10.2811   63.8957  418.1871  432.6775  442.0963  451.5151  445.7189  422.5342   67.5183    8.8320    5.9339];
objmask = poly2mask(poly_x, poly_y, size(im_obj, 1), size(im_obj, 2));

center_x = 530;    % display x coord where center of object should be placed
bottom_y = 1650;       % display y coord where bottom of object should be placed

padding = 64;   % You may want to play with this parameter
[im_s, mask_s] = alignSource(im_obj, objmask, im_bg, center_x, bottom_y, padding);
mask_s = im2double(mask_s);
% % Apply your blending method
result2 = cut_and_paste(im_bg, im_s, mask_s);
% Display:  target image, source image, mask, then blended result
figure; montage({im_bg, im_obj, mask_s, result2});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is your function that implements the blending method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function im_cut_and_paste = cut_and_paste(im_bg, im_s, mask_s)
im_cut_and_paste = im_s.*mask_s + im_bg.*(1-mask_s);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Below are helper functions.  You DO NOT NEED TO MODIFY
% any of the code below.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [poly_x, poly_y] = getPolygonForMask(im)
% Asks user to draw polygon around input image.
disp('Draw polygon around source object in clockwise order, q to stop');
fig=figure; hold off; imagesc(im); axis image;
poly_x = [];
poly_y = [];
while 1
    figure(fig)
    [x, y, b] = ginput(1);
    if b=='q'
        break;
    end
    poly_x(end+1) = x;
    poly_y(end+1) = y;
    hold on; plot(poly_x, poly_y, '*-');
end
close(fig);
end


function [center_x, bottom_y] = getBottomCenterLoc(im_t)
disp('choose target bottom-center location');
fig=figure; hold off; imagesc(im_t); axis image;
figure(fig)
[center_x, bottom_y, ~] = ginput(1);
close(fig);
end


function [im_s2, mask2] = alignSource(im_s, mask, im_t, center_x, bottom_y, padding)
% Inputs:  source image, mask, target/background image, ...
% center_x, bottom_y are the coordinates of the bottom center location on the target image
% padding is the number of extra rows/coumns to include around the
% object to allow for feathering/blending.

% Outputs: an aligned source image and also an aligned blending mask.

% find the bounding box of the mask, and enlarge it by the amount of
% padding
[y, x] = find(mask);
y1 = min(y)-1-padding; y2 = max(y)+1+padding;
x1 = min(x)-1-padding; x2 = max(x)+1+padding;
im_s2 = zeros(size(im_t));

yind = (y1:y2);
yind2 = yind - max(y) + round(bottom_y);
xind = (x1:x2);
xind2 = xind - round(mean(x)) + round(center_x);

% if the padding exceeds the image boundaries,
% clip to image boundary
yind(yind > size(im_s, 1)) = size(im_s, 1);
yind(yind < 1) = 1;
xind(xind > size(im_s, 2)) = size(im_s, 2);
xind(xind < 1) = 1;

yind2(yind2 > size(im_t, 1)) = size(im_t, 1);
yind2(yind2 < 1) = 1;
xind2(xind2 > size(im_t, 2)) = size(im_t, 2);
xind2(xind2 < 1) = 1;

y = y - max(y) + round(bottom_y);
x = x - round(mean(x)) + round(center_x);
ind = y + (x-1)*size(im_t, 1);
mask2 = false(size(im_t, 1), size(im_t, 2));
mask2(ind) = true;

im_s2(yind2, xind2, :) = im_s(yind, xind, :);
end

