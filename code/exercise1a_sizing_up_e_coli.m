%This script will introduce you to the syntax and various operations in the
%MATLAB analysis language as well as introduce you to some image processing.
%and sizing up E. coli. There are many different programming languages
%(python, C++, java, julia, matlab, etc) that are all very useful for
%scientists in every discipline. While we will use Matlab for this course,
%I urge you to not subscribe to any language with religous fervor.

%There are several options, buttons, and windows in the Matlab GUI. The two
%most useful windows for you will the the editor (scripting window) and the
%command window (>>). The editor is where we will spend most of our time as
%we write various scripts to perform analysis, simulations, and
%calculations. However, the command window is good for testing small
%snippets of code. The command window does not store your entries which is
%why the editor window is so useful. To learn some of the Matlab syntax,
%let's enter a few things into the command window. 

1 + 1 %Should give us 2
2 * 8 %Should give us 16
exp(2) %Should give us ~7.4.

%We can also store values as variables.
a = 10
b = 2 * a %Should give us 20. 

%Notice that every entry we have made so far has automatically been
%printed. We don't alwyas want to see this, especially when we are
%generting huge tables or loading images. To suppress output, we simply
%need to add a semicolon (;) to the end of the line. 
c = a^100
d = a^200; %This line won't print. 

%We can also make ranges of values in a similar way to variables. 
values =[0, 1, 1, 2, 3, 5]; %Fibonacci sequence!

%We can index the entries in values by using parenthesis.
values(1) %should be 0
values(5) %should be 3.

%Matlab stores everyting as matrices. 'values' is actually a vector -- a
%one dimensional matrix. We will use these a lot throughout the course. We
%can generate vectors in a number of ways. Let's try to make a time vector
%with evenly spaced intervals. 
time = 1:1:1000; %Count from 1 to 1000 taking steps of 1. 
time = 1:10:1000; %Count from 1 to 1000 taking steps of 10.

%Now that we have the basic syntax of Matlab down let's give it a test run
%on some real data. 

%In the following lines of code, we will use an image of a graticule to 
%measure the distances between pixels of a camera. We will then use this 
%value to place a scale bar on an image of cells, as should always be done 
%in any scientific image.

%We will begin by reading in the image of the graticule. Remember, an image is
%just data -- a simple two-dimensional array in which element corresponds to a
%pixel value.

%Read in the image of the graticule. 
grat_im = imread('../data/SizingupEcoli/Graticule100x.tif');

%If we just display the properties of the grat_im variable, we will see that it
%is just a simple array!
grat_im;

%Let's take a look at the image to see what we are dealing with. 
imshow(grat_im);

%Oh no! Our image appears to be only black! This is because the image is
%actually 12 bit, but is being displayed as a 16 bit image. There is
%information in those pixels, but they are simply being displayed on a
%different scale. We can rescale all of the pixels in this image as
%follows. 
imshow(grat_im, []);

%Much better. This image shows a graticule -- a microscopic ruler. Each
%major division on this image is 10µm apart. If we consider this image as
%an array, we see that if we were to go across a given row of the image,
%there would be a periodic oscillation in pixel values. Dark values would
%correspond to the ticks in the graticules while the white spaces would
%correspond to the spaces. Using this, let's extract the pixel value
%information for a single row in the image. Let's figure out what the size
%of the image is. 
%whos grat_im;

%This tells us that the image is 982x1311. Let's look at the pixel values
%for row 491, excatly down the middle. 
line_profile = grat_im(491,:);

%We'll plot it against the legth of the x axis of the image. 
x = 1:1:length(line_profile); % A vector from 1 to the length of the 
                              %line_profile taking steps of 1.
plot(x, line_profile, 'r-'); %Plot the line_profile in red.

%Every good plot should have labels. 
xlabel('x position');
ylabel('pixel value');

%Just by zooming in on the image, we can see that there is a valley in the
%pixel value at about pixel number 100 and another at 250. This means that
%by our crude estimate, the disance between pixels is as follows
crude_ip_dist = 10 / 150;

%which is about 66 nm. This is actually a pretty good measure. If we want
%to be a little more creative, we can use mouse clicks to record the
%positions of the valleys and take the difference between those. Let's give
%that a shot. 
clicks = ginput(2); %Will record the first two clicks on the plot.

%Now if we look at clicks, it stored as an array of four values. The first
%column is the x-coordinate and the second is the y-coordinate. Taking the
%difference of the first two will give us the distance. 
diff_clicks = clicks(2,1) - clicks(1,1);
click_ip_dist = 10 / diff_clicks;

%This interpixel distance is about the same as we got by our crude
%estimate. Now that we have an idea of what the distance between pixels is,
%we can apply a scale bar to our image. Let's load it up. 
cell_im = imread('../data/SizingupEcoli/Ecoli100x.tif');

%For fun, let's take a look at it. 
imshow(cell_im, []); %Remember to rescale!

%Using clicks again, let's find out the length of one of these bacteria in
%pixels.
cell_clicks = ginput(2);

%We can determine the length of the bacterium using the pythagorean
%theorem.
cell_length_pix = sqrt((cell_clicks(1, 1) - cell_clicks(2, 1))^2 +...
    (cell_clicks(1,2) - cell_clicks(2,2))^2);

%Now it's a simple multiplication to get the physical distance. 
cell_length_micron = click_ip_dist * cell_length_pix;

%Not too bad! Let's put a 10 micron scale bar on our image. We can do that
%by changing a row of pixels 10 microns long on the image all to black. 
scale_bar_length = 10 / click_ip_dist;
copy_im = cell_im; %Copy the image
copy_im(900:920, 20:20 + round(scale_bar_length)) = 0;

%Show the image
imshow(scale_image, [])

%And let's save it for fun!
saveas(gcf, 'Ecoli_with_scalebar.tif'); %gcf = get current figure.