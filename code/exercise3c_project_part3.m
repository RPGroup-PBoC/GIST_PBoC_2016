%This script will segment a bunch of images.
%Do our standard segmentation procedure through a number of images to get
%an idea of the areas. 

%Get a list of image names. 
dir_list = '../data/lacI_titration_data/';
phase_images = dir([dir_list 'noLac_phase*.tif']);

%Let's extract all the cell areas out of these images. 
cell_areas = []; %empty vector where we'll add areas. 

for i=1:length(phase_images);
    
    %Read the image. 
    im_phase = imread([dir_list phase_images(i).name]);
    
    %Normalize it. 
    im_norm = mat2gray(im_phase);
    
    %Gaussian blur it and subtract it. 
    im_blur = imgaussfilt(im_norm, 50.0); %Radius of 50 pixels. 
    im_sub = im_norm - im_blur;
    
    %Renormalize the image. 
    im_filt = mat2gray(im_sub);
    
    %Apply a threshold
    im_thresh = im_filt < 0.3;
    
    %label it. 
    im_label = bwlabel(im_thresh);
    
    %Get the region properties. 
    props = regionprops(im_label, 'Area');
    
    %Package the areas into an array. 
    areas = [props.Area];
    cell_areas = [cell_areas areas];
end

hist(cell_areas);

