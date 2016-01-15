function [areas total_intensities mean_intensities] = extract_int(seg_mask, fl_im)
%This function takes a given segmentation mask and fluorescence image and
%returns the area of each cell, the total fluorescence intensity, and the
%mean intensity of each cell. 
%
%Parameters
%------------
% seg_mask : 2D-matrix, image
%    A labeled binary mask from which regions are identified. 
% fl_im  : 2D-matrix, image
%    A fluorescence intensity image from which mean and total intensity is 
%       computed. 
%
%Returns
%---------
% areas : 1-dimensional vector
%   A vector whose components are the cell areas. 
% total_intensity : 1-dimensional vector

%Load up the fluorescence image. 
im_fl = imread(fl_im);

%Extract the cell areas. 
props = regionprops(seg_mask, 'Area');
areas = [props.Area]; %This is the first variable that will be returned.

%To keep the intensity information, all we have to do is multipy the mask
%for each individual cell by the fluorescence image. Since indexing our
%labeled image yields a binary mask, multiplication will turn all of the
%background pixels to 0 and and multiply all the intensity values by 1. To
%find the total intensity, all we have to do is sum the image. For the
%mean, we just have to divide the total intensity by the area. To
%accomplish this, we'll do it with a loop.  

%Make empty vectors to add the intensity values. 
total_intensities = [];
mean_intensities = [];
for i=1:length(areas)
    %Find our cell of choice.
    cell = (seg_mask==i);
    
    %Multiply our fluorescence image and our mask. 
    cell_fl = immultiply(cell, im_fl);
    
    %Find the total intensity. 
    cell_int = sum(sum(cell_fl));
    
    %Find the mean intensity. 
    cell_mean = cell_int / areas(i);
    
    %Package and return!
    total_intensities = [total_intensities cell_int];
    mean_intensities = [mean_intensities cell_mean];
end

end

    