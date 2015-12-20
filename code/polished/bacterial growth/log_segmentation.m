function segmentation = log_segmentation(im)
%Normalize the image. 
im = mat2gray(im);

%Apply a laplacian of gaussian filter. 
im_log = edge(im, 'log');

%Fill the holes.
im_fill = fill(im_log, 'holes');

%Delete the small objects
segmentation = bwareaopen(im_fill, 100, 4)

