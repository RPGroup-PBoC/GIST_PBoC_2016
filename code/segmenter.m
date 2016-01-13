%The following code is an example of a matlab functions. Unlike most other
%programming languages, matlab functions must exist in their own file free
%from all other code. The file will always start with the word function and
%is then followed by the name of the variable the function will return. In
%this case, it is 'seg_mask'. The next name ('segmenter') is the actual
%name of the function we will call. Followed are the various arguments we
%can pass to it sandwiched inbetween parenthesis.
function seg_mask = segmenter(filename, radius, threshold, small_area, big_area)
%This function segments an image and returns the segmentation mask.
%
%
%Parameters:
%------------
% filename : string
%   Name of the image file to be segmented. 
% radius : float 
%   Radius to use during the gaussian blur smoothing. 
% threshold : float
%   Threshold below which cells will be selected.
% small_area: int
%   Lower bound of area filter. 
% big_area : int
%   Upper bound of area filter. 

%Load the image. 
im_phase = imread(filename);
    
%Normalize it!
im_norm = mat2gray(im_phase);
    
%Blur with a 50 pixel radius and subtract. 
im_blur = imgaussfilt(im_norm, radius);
im_sub = im_norm - im_blur;
im_sub = mat2gray(im_sub); %Renormalization
    
%Apply a threshold. 
im_thresh = im_sub < threshold;
    
%Label our image.
im_label = bwlabel(im_thresh);
    
%Extract the region properties of our image. 
props = regionprops(im_label, 'Area');
areas = [props.Area];
    
%Find the cells which meet our area requirement. The 'find' command will
%return the indices at of the areas vector which meet our filtering
%requirement. 
approved_cells = find((areas > small_area) & (areas < big_area));
    
%Add the approved cells. We will do this by generating an image of zeros
%and adding the binary image of 
final_image = zeros(size(im_label)); %Generates an empty image.
for i=1:length(approved_cells)
    final_image = final_image + (im_label==approved_cells(i)); %Adds them
end

%Label our final image.
seg_mask = bwlabel(final_image);
    
end
    