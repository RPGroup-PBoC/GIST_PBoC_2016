%In part III of our matlab project, we will learn how to process a series
%of image, extract area values, and write our very first function! At the
%end of the last exercise, we saw that we had a distribution of areas, but
%it was pretty hard for us to identify good thresholds. Today, we'll get a
%better idea of what a typical cell looks like by segmenting even more
%cells.

%We will begin by listing all of the phase images. 
phase_ims = dir('noLac_phase*.tif');

%Now we can loop through every image and extract the area.
cell_areas = []; %An empty array to which we will concatenate our areas. 
for i=1:length(phase_ims)
    %Load the image. 
    im_phase = imread(phase_ims(i).name);
    
    %Normalize it.
    im_norm = mat2gray(im_phase);
    
    %Blur with a 50 pixel radius and subtract. 
    im_blur = imgaussfilt(im_norm, 50.0);
    im_sub = im_norm - im_blur;
    im_sub = mat2gray(im_sub);
    
    %Apply a threshold. 
    threshold = 0.3;
    im_thresh = im_sub < threshold;
    
    %Label our image.
    im_label = bwlabel(im_thresh);
    
    %Extract the region properties of our image. 
    props = regionprops(im_label, 'Area');
    areas = [props.Area];
    
    %Store our areas. 
    cell_areas = [cell_areas areas]; %This concatenates the lists. 
end

%That was pretty simple. Lets take a look at the distributions
hist(cell_areas, 25); %Arbitrarily using 25 bins. 
xlabel('areas');
ylabel('counts');
    
%To me it looks like there are three semi-distinct distributions of cells.
%It seems that there are only a few things bigger than 800 pixels and a
%bunch smaller than 100. Since these ranges are outside the typical range
%for a bacterium, we can say that an 'ideal bacterium' would be between
%these two values. Rather than typing all of this junk out again and again
%for each image. Let's write a function to make this work for us! Please
%see the accompanying 'segmenter.m' file for more detail. For this function
%to work, it either needs to be in the same working directory as our
%current file or within our Matlab PATH. 


%Let's apply the mask to the fifth image in our sample. 
mask_5 = segmenter(phase_ims(5).name, 50.0, 0.3, 200, 800);
imshow(mask_5);

%That looks pretty good! We can overlay our mask with our phase image by
%making it an RGB image. Let's give that a shot. 
%Load and normalize the phase image. 
im_norm = mat2gray(imread(phase_ims(5).name));
merged_image = cat(3, im_norm, im_norm, im_norm + mask_5); %Mask will be blue. 
imshow(merged_image)
%Pretty awesome!