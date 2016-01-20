%lets determine the spring constant from our Trapped bead data
% We need to determine the mean square displacement
% K trap = KBT/ msd

%load in our bead images
images = dir('img*.tif');

%Lets just make sure that everyone is in the correct directory 
%(expect length(images) = 300
%length(images)

%STEP 1: We need to figure out how to threshold to find our bead. 
%lets load one image, renormalized pixel values, and then figure it out

%bead = imread(images(1).name);
%bead_renorm = mat2gray(bead);
%imtool(bead_renorm)

%okay, so the center is very bright (value ~0.8), but then we have a halo of very low
%intensity (value ~0.07), and then our background (value ~0.15). Lets just
%threshold to get the halo and use this to find the threshold. Note that
%due to the contrasting, if you try to just monitor the center bright
%circle, the bead will not appear to move and you will end up with a very
%high spring constant. Lets take a value of 0.09.
threshold = 0.09;

for i =1:(length(images))
    %load image i
    im = imread(['' images(i).name]);
    
    %lets renormalize our image 
    im_renorm = mat2gray(im);
    
    %threshold image to find bead
    % this should allow us to identify outer 'halo' of bead.
    im_thresh = im_renorm <= threshold;
    
    % lets label objects in image and get properties
    im_label =  bwlabel(im_thresh);
    props = regionprops(im_label, 'Area', 'Centroid');
    
    % now we want to find the bead. 
    % It might be that our thresholding resulted in multiple objects found.
    %our largest object should be the bead. 
    [bead_area bead_index] = max([props.Area]);
    
    %finally, lets get the position of the bead in image i.
    position(i,:) = props(bead_index).Centroid;
    
end

%plot position of all our images
plot(position(:,1), position(:,2))
xlabel('X position (pixels)')
ylabel('Y position (pixels)')
set(gca,'FontSize',18);

% msd = <x^2> = < (position(i) - mean_position)^2 > 
% = mean( (position(:,1) - mean_pos)^.2))

%Lets determine the mean position along X and Y. This will
% produce a 2D array [X Y]
mean_pos = mean(position);

%lets calculate the mean square displacement
msd_x = mean( (position(:,1) - mean_pos(1)).^2);
msd_y = mean( (position(:,2) - mean_pos(2)).^2);

%We made it! We have the trajectory of our bead and have calculated the 
% mean square displacement. Now we can determine the spring constant, where I'll consider
%X and Y seperately.

%one last thing though. We want it in units force/distance (pN/ um). I
%measured this using a graticule like you did in class with ecoli. I found
%that 50 um = 1200 pixels.
pixel_conversion = 50 /1200; % 50 um / 1200 pixels

%okay, K trap = KBT/ (msd * pixel_conversion^2);
KBT =  4E-3; %pN um

k_x = KBT / (msd_x * pixel_conversion^2)
k_y = KBT / (msd_y * pixel_conversion^2) % pN/um

    