%In part four of the Matlab project, we will write our own function to
%extract intensity information from a provided fluorescence image. When
%quantifying fluorescence signals from cells, one has to consider what
%value is the most informative. In our case, we will compare the mean
%intensities and the total intensities for each cell. 

%So far, we have only looked at phase contrast images. In these imags,
%bacteria are always dark on a light background. Let's take a look at a
%fluorescence image.
im_fitc = imread('noLac_FITC_0004.tif');
imshow(im_fitc, [])

%We can see in this case that all of the bacteria are bright on a dark
%background. If you look closely, you'll also notice the lack of a bright
%halo around the cells, which we see in our phase contrast images. For this
%reason, many people choose to segment cells in fluorescence. However, this
%requires that there is another channel to segment on (such as RFP which is
%being constitutively expressed). Since our only fluorescence channel is
%the one that we are interested in quantifying, we won't go through
%segmentation on this channel. In fact, we won't do anything to this
%channel. 

%To extract the intensity values, we'll write another function that will
%reduce the amount of typing that we have to do. Please see the associated
%file 'extract_int.m' for more details. 

%With our function in hand, let's extract some intensity information.

%Load all of phase and fluorescence images. 
phase_ims = dir('noLac_phase*.tif');
fitc_ims = dir('noLac_FITC*.tif');

%We'll make some empty arrays to store our values.
all_cell_areas = [];
all_cell_int = [];
all_cell_mean = [];

%Now we just have to iterate through each image and run our functions. 
for i=1:length(phase_ims)
    %Apply our segmentation function.
    seg = segmenter(phase_ims(i).name, 50.0, 0.3, 200, 800);
    
    %Extract the intensities and areas. 
    [im_areas im_int im_mean] = extract_int(seg, fitc_ims(i).name);
    
    %Add them to our final vector. 
    all_cell_areas = [all_cell_areas im_areas];
    all_cell_int = [all_cell_int im_int];
    all_cell_mean = [all_cell_mean im_mean];
end

%Now let's plot all of our results. 
plot(all_cell_areas, all_cell_int, 'o');
hold on;
plot(all_cell_areas, all_cell_mean, 's');
legend('total int', 'mean int');
xlabel('cell area (pixels)');
ylabel('total intensity (counts)');
hold off; 

%We can see that the total intensity of each cell seems to increase
%linearly with cell area while the mean intensity is more or less flat.
%For the rest of the matlab project, we will look at the mean pixel
%intensity of a lot of cells to calculate the fold change in gene
%expression. 