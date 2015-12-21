function mean_ints = extract_mean_int(image_dir, phase_pattern, fl_pattern, thresh, auto)
%Sort through the files and find all images that contain the pattern.
phase_images = dir([image_dir phase_pattern]);
fitc_images = dir([image_dir fl_pattern]);
depot = [];
for i=1:length(phase_images)
        int_im = imread([image_dir fitc_images(i).name]);
        seg_im = segmentation([image_dir phase_images(i).name], thresh);
        
    %Now extract the mean intensities for each image. 
    props = regionprops(seg_im, int_im, 'MeanIntensity');
    
    %Now append it to the depot list. 
    depot = [depot [props.MeanIntensity]];
end

%Now return it.
mean_ints = depot - auto;
end
