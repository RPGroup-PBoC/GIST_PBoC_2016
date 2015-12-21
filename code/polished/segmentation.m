function seg_mask = segmentation(fname, thresh)
    %Load the file. 
    im = imread(fname);
    
    %Convert it to a float. 
    im = mat2gray(im);
    
    %Do a gaussian filter. 
    im_filt = imgaussfilt(im, 20);
    
    %Subtract the two. 
    im_sub = im - im_filt;
    
    %Now convert that to a float. 
    im_sub = mat2gray(im_sub);
    
    %Apply the threshold
    im_thresh = im_sub < thresh;
    
    %Delete the small objects. 
    im_thresh = bwareaopen(im_thresh, 100);
    
    %Clear the border. 
    im_cells = imclearborder(im_thresh);
    
    %Label the image and return it. 
    seg_mask = bwlabel(im_cells);
end