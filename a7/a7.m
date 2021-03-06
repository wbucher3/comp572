%{

YOUR COMMENTS:

Please include brief comments here describing the effects and quality of
results (3-5 lines).  Include anything else about the images you would like
to share.

The effect happening is pretty much portrait mode from our smart phones! 
It is using mask to blur the background using a weight average of the pixels within a disk filter.
This weighted average is important so we can use less pixels around the foreground object and still achieve the same blur 
    when the disk is larger. 
This method works really well when using it with backgrounds with a lot going on so the blur is shown more. 
A plain background can hide the blur, making it almost look like there is no effect present.
It can also add a cool effect turning lights into a bunch of disk, I tried to do this with a sunset pic
    i recently took while following my Dad driving, however it didnt work too well because there wasnt a lot of lens flare. 

(Optional) Also mention if you obtained more compelling results by using a 
different filter shape than a disk.

%}

close('all');   % close all open figures so we start with a clean slate!



I=im2double(imread('https://raw.githubusercontent.com/wbucher3/comp572/main/pictures/womanandmana7.jpg'));

% Get foreground mask (part that stays sharp) from the user

% For the given image, a mask is provided as an image
mask = im2double(imread('https://raw.githubusercontent.com/wbucher3/comp572/main/pictures/maska7.png'));

% Define the bokeh filter shape
% A simple disk filter is provided as default
% For extra credit you may optionally define a different shape, e.g., hexagon, starburst, heart etc.

radius = 15;            % choose this carefully for each image
bokeh_shape = fspecial('disk', radius);

result1a = method1(I, mask, bokeh_shape);
result1b = method2(I, mask, bokeh_shape);
result1 = method3(I, mask, bokeh_shape);

figure; montage({I, result1a, result1b, result1});


%%
% -------------------------------------------------------------------------
% IMPORTANT NOTE (please read carefully)
% -------------------------------------------------------------------------
% Repeat your method for 5 more sets of images.  But remember that for
% these you must interactively specify the mask ONE TIME.
%
% Work in the Matlab computer app or the full Matlab Online version
% (https://matlab.mathworks.com) first to get the coordinates for alignment
% and cropping.  Then hard-code these in your program before migrating to
% the Matlab Grader website for submission.
%
% -------------------------------------------------------------------------


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% IMAGE 1 %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I=im2double(imread('https://raw.githubusercontent.com/wbucher3/comp572/main/pictures/friends.jpg'));

% Interactively draw the foreground mask as a polygon

%{
[poly_x, poly_y] = getPolygonForMask(I);
disp("Copy the values of the vectors poly_x and poly_y from the " + ...
    "Command Window below and hard code them inside your code for " + ...
    "submission via the Grader website.");
poly_x        % display x coords of polygon
poly_y        % display y coords of polygon

%}
% Once you have these coordinates, comment out the call to getPolygonForMask() 
% and hard code the coordinates instead.



poly_x = 1.0e+03 * [  1.6946    1.8944    2.1087    2.2597    2.3328    2.4302    2.4302    2.0941    1.7677    1.3585    1.1636    0.9687    0.9687    1.2659    1.3536    1.3341    1.3780    1.4315    1.5387    1.6459    1.6946];
poly_y = 1.0e+03 * [  1.6593    1.4547    1.3719    1.4547    1.5375    1.7178    2.4972    2.8577    2.9064    2.8187    2.6823    2.3365    2.1562    2.1367    2.0490    1.9467    1.8834    1.8395    1.7178    1.6788    1.6593];


mask = poly2mask(poly_x, poly_y, size(I, 1), size(I, 2));

% Define the bokeh filter shape
% A simple disk filter is provided as default
% For extra credit you may optionally define a different shape, e.g., hexagon, starburst, heart etc.

radius = 30;            % choose this carefully for each image
bokeh_shape = fspecial('disk', radius);

result2 = method3(I, mask, bokeh_shape);

figure; montage({I, result2});



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% IMAGE 2 %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


I=im2double(imread('https://raw.githubusercontent.com/wbucher3/comp572/main/pictures/DennyAndMe.jpg'));

poly_x = 1.0e+03 * [  1.0801    0.9357    0.8394    0.8875    1.1571    1.2919    1.3112    2.2355    2.2547    1.9563    1.8022    1.8600    1.8889    1.8022    1.4556    1.2245    1.2149    1.0993];
poly_y = 1.0e+03 * [  1.7095    1.8443    1.9791    2.1332    2.3835    2.6435    3.0767    3.1249    1.9406    1.8443    1.5266    1.3244    1.1029    0.8815    0.8333    1.0741    1.4207    1.6903];
mask = poly2mask(poly_x, poly_y, size(I, 1), size(I, 2));
radius = 20; 
bokeh_shape = fspecial('disk', radius);
result2 = method3(I, mask, bokeh_shape);
figure; montage({I, result2});


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% IMAGE 2 %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


I=im2double(imread('https://raw.githubusercontent.com/wbucher3/comp572/main/pictures/alvaSitting.jpg'));

poly_x = 1.0e+03 * [  0.6503    0.7850    0.8538    0.9369    0.9626    0.9712    0.9541    0.9741    1.0486    1.1804    1.0572    0.8595    0.7621    0.6073    0.3952    0.2548    0.2262    0.2090    0.2090    0.3236    0.3924    0.4038    0.5041    0.6474];
poly_y = 1.0e+03 * [  0.4834    0.5178    0.5722    0.6496    0.7556    0.8788    0.9619    1.0794    1.1625    1.2514    1.3517    1.4405    1.3316    1.3775    1.3631    1.3115    1.1711    0.9906    0.8903    0.8215    0.7355    0.6467    0.5722    0.4862];

mask = poly2mask(poly_x, poly_y, size(I, 1), size(I, 2));
radius = 15; 
bokeh_shape = fspecial('disk', radius);
result2 = method3(I, mask, bokeh_shape);
figure; montage({I, result2});


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% IMAGE 3 %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


I=im2double(imread(['https://raw.githubusercontent.com/wbucher3/comp572/main/pictures/Denver.jpg']));

poly_x = 1.0e+03 * [ 1.0822    1.2327    1.3049    1.3530    1.4252    1.5155    1.5456    1.6118    1.6720    1.6840    1.6720    1.7322    1.9608    2.4182    2.5446    2.9658    2.7913    2.1654    1.2146    0.3781    0.4864    0.9438    1.0461    0.9799    0.7873   0.5707   0.4503    0.5226    0.7573    1.0822];
poly_y = 1.0e+03 * [ 0.7858    0.7257    0.7858    0.9002    0.9483    1.0867    1.2552    1.4177    1.6223    1.7788    1.9052    2.0737    2.1579    2.1098    2.0917    2.3746    3.0185    3.2592    3.3374    3.0245    2.7477    2.4949    2.3625    2.1158    1.9413   1.6945  1.3034    1.0807    0.8340    0.7858];

mask = poly2mask(poly_x, poly_y, size(I, 1), size(I, 2));
radius = 45; 
bokeh_shape = fspecial('disk', radius);
result2 = method3(I, mask, bokeh_shape);
figure; montage({I, result2});


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% IMAGE 4 %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I=im2double(imread(['https://raw.githubusercontent.com/wbucher3/comp572/main/pictures/mustangSunset.jpg']));

poly_x = 1.0e+03 * [ 1.6419    1.7984    1.8465    1.9007    1.9307    1.9368    1.7261    1.3530    1.3410    1.4132    1.4674    1.6298];
poly_y = 1.0e+03 * [ 2.2662    2.2662    2.3385    2.4107    2.5792    2.6213    2.6694    2.6935    2.4829    2.3685    2.2843    2.2723];

mask = poly2mask(poly_x, poly_y, size(I, 1), size(I, 2));
radius = 24; 
bokeh_shape = fspecial('disk', radius);
result2 = method3(I, mask, bokeh_shape);
figure; montage({I, result2});


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% IMAGE 5 %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I=im2double(imread(['https://raw.githubusercontent.com/wbucher3/comp572/main/pictures/mirandaandfiona.jpg']));

poly_x = 1.0e+03 * [ 0.8423    0.9346    1.0829    1.2246    1.2444    1.1686    1.0269    0.9774    1.1521    1.1818    0.5194    0.5523    0.5886    0.6248    0.5194    0.4271    0.4172    0.4897    0.6512    0.7698    0.8423];
poly_y = 1.0e+03 * [ 0.5657    0.5459    0.6283    0.8194    0.9677    1.1061    1.1688    1.2380    1.3335    1.4489    1.3665    1.2709    1.2610    1.1589    1.1358    1.0238    0.8557    0.7272    0.5855    0.5426    0.5690];

mask = poly2mask(poly_x, poly_y, size(I, 1), size(I, 2));
radius = 20; 
bokeh_shape = fspecial('disk', radius);
result2 = method3(I, mask, bokeh_shape);
figure; montage({I, result2});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This are the functions that implement bokeh
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function result = method1(I, mask, filter)
    I_blur = imfilter(I, filter, 'replicate');
    result = I_blur .* (1 - mask) + I .* mask;
end

function result = method2(I, mask, filter)
    bg = I .* (1 - mask);
    bg_blur = imfilter(bg, filter, 'replicate');
    result = bg_blur .* (1 - mask) + I .* mask;
end

function result = method3(I, mask, filter)
    %%% get the foreground from the mask
    foreground = I .* mask;

    %%% big sum stuff
    bg_numerator = imfilter(I .* (1 - mask), filter, 'replicate');
    bg_denominator = imfilter(1-mask, filter, 'replicate');
    %%% divide those sums for the final background blurrrrrr
    background = bg_numerator ./ bg_denominator;


    %%% setting all NaN to zero - https://www.mathworks.com/matlabcentral/answers/85568-how-to-convert-nan-to-zero
    %%% NaN do not work with numbers so we have to do it
    background(isnan(background)) = 0;
    %%% finally apply the mask to the blurred image
    background = background .* (1 - mask);

    %%% combine the foreground and background
    result = foreground + background;

    
    
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
