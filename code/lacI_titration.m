function [mean_intensities, num_cells] = lacI_titration(pattern, phase, fitc, auto);
%This function takes a given file name pattern and computes the mean
%intensity as well as the total number of cells segmented for each sample
%set. 
%
%Parameters
%----------
% pattern : cell
%   A cell containing strings of a pattern to search for in a directory.
% phase : string
%   A string the suffix of the phase contrast images. 
% fitc  : string
%   A string of the suffix of the fluorescence images.
% auto : float
%   A float of the autofluorescence value to be subtracted. 
%Returns 
%---------
% mean_intensities : float
%   A value for the mean intensity of all cells for the sample.
% num_cells : int
%   The total number of cells segmented. 


%We will generate the file names based off the appropriate suffix and the
%provided patterns. Since 'pattern' is a cell, we must first transform it
%to a matrix in order to concatenate the strings. 
phase_ims = dir([cell2mat(pattern) phase]);
fitc_ims = dir([cell2mat(pattern) fitc]);

%Now that we have all of the desired files, we simply have to use our
%'segmenter' and 'extract_int' functions to get the information we want. 
cell_mean_ints = [];
for i=1:length(phase_ims);
    
    %Use our segmenter function to generate a segmentation mask. 
    seg = segmenter(phase_ims(i).name, 50.0, 0.3, 200, 800);
    
    %Collect the mean intensities. 
    [areas, total, means] = extract_int(seg, fitc_ims(i).name);
    
    %Subtract the provided autofluorescence data. 
    means = means - auto;
    
    %Add it to our vector. 
    cell_mean_ints = [cell_mean_ints means];
end

%Now we just have to find the mean of the extracted mean pixel values and
%determine the number of cells segmented!
mean_intensities = mean(cell_mean_ints);
num_cells = length(cell_mean_ints);

%And we're done!
end