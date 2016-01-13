%This script computes the growth rate of a bacterial colony over time
%through high-magnification microscopy. The provided images are of E. coli
%cells growing on a hard agar substrate supplemented with the minimal
%ingredients needed to allow cells to grow. The images are at a 
%magnification of 100x and images are taken at 10 minute intervals.
%In the coming code, we will perform some basic segmentation on these
%images and compute the growth rate of these wonderful cells. 

%Let's start by looking at this growing colony somewhere in the middle of
%the movie. Note that the data on my computer lives in a directory above
%the current working directory in a file called 'data'. Ensure that this is
%changed to the appropriate working directory on your computer.
last_im = imread('../data/colony_growth/EcoliGrowth15.tif');

%Notice that all of the cells are black and the background is a light gray.
%To ensure that each image has the same range of pixel values, we'll
%normalize the image.
im_norm = mat2gray(last_im);

%Now all of the pixel values range from 0 to 1.0. Since there are a bunch
%of cells in this image, a histogram of this image would show a hump of
%pixel values that are darker than the background. Let's take a look.
imhist(im_norm, 1000); %Arbitrarily chose 1000 bins.

%There are some interesting features in this histogram. There is a very
%strong peak around 0.5. Everthing here and above are the background
%pixels. We can see a small hump below this, however. Let's just try
%picking a value of 0.4 and say that everything below this are bacteria.
%Let's see what this does to the image. 
threshold = 0.4;
im_thresh = im_norm < 0.4;

%We can see two humps -- We'll say anything above 0.3 is a bacterium. 
threshed_im = im_norm < 0.3;
imshow(im_thresh);

%Cool! All of the bacteria are white (1's) and the background is black 
%(0's). To determine the bacterial area in the image, we can simply sum
%across the image!
bacterial_area = sum(sum(im_thresh)); %Need two sums for the two dimensions
                                      %of the image. 
                                      
bacterial_area;

%Now that we have a way to determine the cell area in a given image, We can
%do this same procedure for every image that we have. To do this, we'll use
%a for loop. We'll start by loading up all of the image files into
%something we can loop through. 
images = dir('../data/colony_growth/*.tif'); 
images(10).name; %This will give us the name of the 10th image.

%Now, all we have to do is loop through each image and apply the above
%procedure. Let's do it!
for i=1:length(images) 
    %Load the image. We also need to include the directory. 
    im = imread(['../data/colony_growth/' images(i).name]);
    
    %Normalize it.
    im_norm = mat2gray(im);
    
    %Apply the threshold. 
    cells = im_norm < threshold;
    
    %Compute the cell area. 
    cell_area = sum(sum(cells));
    
    %Now store the cell area in a vector we will use later. 
    areas(i) = cell_area;
    
    %And we are finished!
end

%Now we can take a look through our areas vector and see how that scales
%with time. Before we can plot it, we need to make a time scale. 
time = 1:10:350; %from 1 to 350 in 10 minute intervals.

%Let's plot it!
plot(time, areas, 'bo');
xlabel('time (min)');
ylabel('area (pixels)');

%What does this look like when placed on a log scale. 
semilogy(time, areas, 'bo');
xlabel('time (min)');
ylabel('area (pixels)');

%That is impressively linear given how rough our segmentation algorithm is.
%Let's fit this trend to a line to find the doubling time. If we assume
%that this growth is exponential, then we can fit the following line. 
%  
%       A_t = A_o * exp(k * t)
%       ln(A_t) = ln(A_o) + k*t
%
%To determine the doubling time, this is a simple rearrangement of the
%above linear equation to
%
%       t_double = ln(2) / k
%
%We'll use MATLAB's polyfit function to do this. 
linear_fit = polyfit(time, log(areas), 1);
slope = linear_fit(1);
intercept = linear_fit(2);

%Done! Now let's compute the doubling time. 
t_double = log(2) / slope;

%That's pretty good! This growth is more slow as they are growing in a
%minimal medium. Let's plot this on our semilog plot to see how nice of a
%fit it is. 
fit = intercept + slope * time;

%Plot the data. 
plot(time, log(areas), 'bo');
hold on %To allow for further plotting.
plot(time, fit, 'k-'); %Plot the fit as a black line. 
xlabel('time (min)');
ylabel('log(area) (pixels)');

