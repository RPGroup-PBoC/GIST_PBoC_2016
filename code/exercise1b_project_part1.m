%In this script, we'll learn some basic facts about images, how to read
%them in matlab, and the basic principles of thresholding. On the course
%website (rpgroup-pboc.github.io/GIST_PBoC_2016)
%there are two images that we will analyze to extract some information 
%about gene expression. While both of these images are of the same field 
%of view, one was taken with phase contrast (noLac_phase_0008.tif) while th other
%was taken with fluorescence (noLac_FITC_0008.tif). We'll use the
%fluorescence image as a measure of the gene expression of a fluorescent 
%reporter, so it is best to not use it for segmentation as to not bias our
%results. For identifying the single bacteria, we'll use thresholding to
%segment the phase image.

%It is important to remember that an image is nothing but data -- it is an
%array of points with a specific value called pixels. The values that these
%pixels can take is related to the construction of the camera and is
%measured as 'bit depth'. To determine the range of pixel values an N bit
%image can take, we simply need to compute 2^N - 1. This subtraction of 1
%is because 0 can be a pixel value as well. For example, a 16-bit image can
%have pixels on the range of 0 -> (2^16 -1) = 0 -> 65535. Let's begin by
%loading the phase contrast image into matlab as an array of values.
im_phase = imread('noLac_phase_0008.tif'); %This loads the phase image as imPhase.

%To extract some information about the phase image, we can use MATLABs
%"whos" directive. 

%whos im_phase %Uncomment this line for output. 

%Notice that this gives us information regarding the name, size, bytes, and
%class (bit-depth). We can see that our image has a resolution of 1024 x
%1344 and is about 2.7 MB. To look at the image, we can use the "imshow"
%command, but we need to think about how the image will be scaled.  
imshow(im_phase);

%Running the above command (without a ;) will show a seemingly black image.
%However, if you use the "Data Cursor" icon in the image window and click
%around, you'll be able to see that the pixels actually have different
%values. We can scale the image to a certain range of values within the
%imshow directive. 
imshow(im_phase, [600 800]); 

%The above command will display the image where the pixel value 600 or
%below will be black and 800 or above will be white. To automatically scale
%the image such that the lowest pixel value is black and the highest is
%white, we can simply leave a pair of empty open/close brackets. 
imshow(im_phase, []);

%Let's look at a few properties of the image. To do this, we can use
%MATLABs "imtool" widget. This widget allows us to make measurements of
%pixel value, distance, crop the image, adjust the contrast, and so on.
imtool(im_phase, []);

%Click on the "inspect pixel value" tool and zoom into one of the bacteria.
%We can easily see that the bacteria are a very different value than the
%rest of the image. We can look at the histogram of the pixel intensities
%of the image using the "imhist" command. The binning is set as 256 by
%default, so let's change this to a binning size of the maximum pixel
%intensity. 
max(im_phase); %This yeilds the maximum of each column in the image. 
max_val = double(max(max(im_phase))); %This yields the maximal pixel value in the image.
min_val = double(min(min(im_phase))); %This yields the minimum pixel value. 
% If you are using a matlab version older than 2014a, you may need to
% declare maxVal as a "double" (as I did above).
imhist(im_phase, max_val);

%The histogram looks very squished. It's hard to get a good hold on the
%range of values to choose a threshold. Let's rescale the x-axis so it only
%goes from the lowest to the highest value. Again, if you are using an older
%version of MATLAB, you may need to declare 
xlim([min_val max_val]);

%Look at the histogram again shows a that there are two peaks. If you
%remember, the bacteria appear as black rods on a bright background. The
%peak at the lower pixel values corresponds to the bacteria. Looking at the
%histogram, we see that a reasonable threshold to use would be 1500. Let's
%say that all the bacteria exist below this threshold. To look at this
%image, we'll use MATLABs logic operations to find the pixels below a
%certain value. Below are some examples. 
1 < 2; %True and outputs "1".
10 > 3; %False and outpust "0".

%Since an image is an array, we can pick out specific pixel values by
%indexing in the order of y,x with y=x=0 corresponding to the top right
%corner of the image. 
im_phase(2,3) > im_phase(10, 100); %Outputs "1" (True!). 

%We can now define our threshold variable and find the bacteria. We'll look
%through each pixel value in the image and change its value to 1 if it is <
%1500 or 0 if it is > 1500. This will produce a binary image which we do
%not need to rescale. 
threshold = 600;
im_thresh = im_phase < threshold;
imshow(im_thresh)

%We can see that we did a pretty okay job of separating the bacteria from
%the background. There are still some problem areas, however. We've also
%separated out junk and large clusters of cells. We'll have to think of a
%clever way to remove them in the future sessions of the project!
