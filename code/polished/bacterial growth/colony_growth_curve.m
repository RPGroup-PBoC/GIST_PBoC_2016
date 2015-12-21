%This script computes the bacterial growth rate of a single colony of E.
%coli cells growing on a minimal medium agarose pad. The cells are imaged
%with both phase contrast and fluorescence so that we can compare and
%contrast various methods of segmentation. 

%Let's begin by loading up a single image and come up with some way to
%identify what is bacterium and what is background. 
data_dir = '../images/colony_growth_data/';
image = 'colony00_frame15_FITC.tif';

%Now we'll load up the image and look at it. 
%im = imread([data_dir image]);
%imshow(im, []) %We need the [] so the image will be rescaled. 

%We can see that the bacteria are white against the black background. An
%easy way to select the bacteria in the image is to draw a threshold. To
%choose a good threshold, we'll look at the histogram of the image. 
%thresh = 200;
%im = im > 200;
%area = sum(sum(im)) * 0.065^2
%That threshold looks pretty good. Let's use that and try to read all of
%the images in the folder. 
ip_dist = 0.065


for i=1:24
    
    if i<10
        im = imread([data_dir 'colony00_frame0' num2str(i) '_FITC.tif']);
    else
        im = imread([data_dir 'colony00_frame' num2str(i) '_FITC.tif']);
    end
    im = im > 200;
    area(i) = sum(sum(im)) * ip_dist^2;
    
end


%This seems to work beautifully. Let's try to figure out what the growth
%rate is. Our model states that cells should grow exponentially with some
%rate constant k. 
%
% N(t) = N(0) * e^(k * t)
%
% Where N(t) is the number of cells at time (t), N(0) is the initial number
% of cells 
%Make a vector of time. 
t = linspace(1, 24*15, 24);

plot(t, area, 'o')
