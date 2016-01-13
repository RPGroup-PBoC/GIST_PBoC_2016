function seg_mask = segmenter(filename, radius, threshold)

%Load the image. 
im = imread(filename);

%Normalize the image. 
im_norm = mat2gray(im);

%Blur it. 
im_blur = imgaussfilt(im_norm, radius);

%Subtract them. 
im_sub = im_norm - im_blur;

%Rescale the intensities. 
im_sub = mat2gray(im_sub);

%Apply the threshold. 
im_thresh = im_sub < threshold;

%Label the image. 
im_lab = bwlabel(im_thresh);

%Get the region properties.
props = regionprops(im_lab, 'Area');
areas = [props.Area];

%Apply the area filter. 
approved_cells = find((areas > 200) & (areas < 800));

%Make the new image. 
im_approved = zeros(size(im_lab));
for i=1:length(approved_cells)
    good_cell = (im_lab==approved_cells(i));
    im_approved = im_approved + good_cell;
end

%Label it. 
seg_mask = bwlabel(im_approved);
end

    
