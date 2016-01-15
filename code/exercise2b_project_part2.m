%In part two of the project, we'll extract some information about the
%objects in our image. For this script, we only need to load the image from
%and can ignore the other details of part 1. 
%Load up the phase image and display it. 
im_phase = imread('noLac_phase_0008.tif');
imshow(im_phase, []);

%As we saw in part I of the project, the bacteria are dark on a light
%background. By looking at the histogram, we can get an idea for what those
%values are. However, the absolute pixel values are dependent on the
%illumination of each individual image. These absolute pixel values will
%change from day-to-day and image-to-image. What is constant, however, is
%that the ratio of bacterial pixel values to the background. We can rescale
%all of the pixel values from 0 to 1 (called  normalization) with a simple
%matlab command called mat2gray. 
im_norm = mat2gray(im_phase); 
imhist(im_norm, 1000); %Showing the histogram with 1000 bins. 

%Now we can see that the pixel values range only between 0 and 1! Great!
%Now we can look at the image without having to rescale the values in our
%viewing window. 
imshow(im_norm);

%If we look at the image, there is some very obvious un-even
%illumination. The upper left-hand image corner of the image is noticeably
%darker than the bottom right-hand corner. If we are applying a simple
%threshold to the image, this will be a problem as background pixels will
%be selected as well. There are many different kinds of image filters we
%can use to remove this type of uneven illumination. Today, we'll try out a
%gaussian filter. In this filter, each pixel of the image is given a value
%that is the weighted average of all the pixels nearby within a given
%radius. Since we don't want to remove all of the bacteria, we an choose a
%radius that is smaller than a bacterium, but larger than the typical
%fluctuations in the image.Before we can filter the image, we need to
%renormalize it.
%We can get rid of that through a gaussian blur.
radius = 50.0; 
im_blur = imgaussfilt(im_norm, radius);
imshow(im_norm, []);

%Now the uneven illumination is very obvious. 
%Now we can subtract the two to see how it improved. 
bg_subtract = im_norm - im_blur;
imshow(bg_subtract);

%That looks pretty gross. That is because the subtraction yields in
%negative values. Let's rescale the entire image to values ranging from 0
%to 1. 
im_norm = mat2gray(bg_subtract);
imshow(im_norm, [])

%Beautiful! The unevel illumination is now totally gone! Now let's try
%thresholding our image as we did yesterday. From the histogram we
%generated a few minutes ago, we can see that a good choice of threshold is
%around 0.3. 
thresh = 0.3;
im_thresh = im_norm < thresh;
imshow(im_thresh);

%That is actually pretty good, although there is some residual junk. In
%part 1, we discussed ways that we could better classify what a bacterium
%is. However, the image we have right now only shows what pixels in the
%image correspond to bacteria. We have not labeled each individual
%bacteria. Before we can start asking what what the area is of each cell,
%we must first be able to isolate each one. We can do this with a simple
%matlab command called "bwlabel" which will identify each individual object
%in an image. 
im_labeled = bwlabel(im_thresh);

%Let's look at the objects found through the labeling. We'll depict the
%objects as a rainbow color that corresponds to their index number. 
imshow(label2rgb(im_labeled));

%imLabeled is now an array with the locations of our segmented objects. To
%determine the number of objects in our segmented image, we can simply find
%the maximum of the array. 
num_objects = max(max(im_labeled));
num_objects; %We have segmented 45 objects. 

%Because imLabeled is an array, we can also extract individual objects and
%compute their properties. Let's look at object number 15.
imshow(im_labeled==15);

%Since the object is composed of only 1's and the background is 0's, we can
%find the area of the object by just summing over the picture. Lets compute
%the area of cell number 15 using this method. 
area = sum(sum(im_labeled==15)); %Area of a single cell is around 300 pixels. 

%Rather than doing this by hand, we can use the 'regionprops' command to
%extract all sorts of information for us. Let's extract the area. 
properties = regionprops(im_labeled, 'Area'); 
properties.Area; %This will print out the area values. 

%To look at the distribution of area's, we need to sort the areas into an
%array. We can do this by calling the above function inbetween square
%brackets. 
areas = [properties.Area];

%Now let's take a look at the distribution of the areas. We'll use 10 bins. 
bins = 10;
hist(areas, bins);

%Remember that a single cell is somewhere around 300 pixels. There seems to
%be a lot of objects below and above this value. We can isolate individual
%cells by applying an area threshold, which is the next step in the
%project.
