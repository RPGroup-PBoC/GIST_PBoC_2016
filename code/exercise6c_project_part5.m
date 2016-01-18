%This is the final portion of our Matlab project! So far, we have learned
%how to segment cells and extract the mean pixel intensities from each
%cell. All that is left is to compute the fold-change in gene expression of
%each sample and compare it to our theoretical description. In class, we
%derived the following equation for the fold-change of the simple
%repression case. 
%
% fold-change = [1 + R/Nns * exp(-dEb / kT)]^-1
%
%where R is the number of repressors in each cell, Nns is the number of
%nonspecific LacI binding sites, dEb is the difference in binding energy
%between the specific and nonspecific sites, and kT is the thermal energy
%of the system. We will start our analysis by writing a function to iterate
%through a number of possible images and extrac the mean intensities. See
%the associated 'lacI_titration.m' function for more details. 

%Give a pattern for Matlab to assemble the image names. We will do this by
%using a 'cell' data type rather than a matrix. In a cell, we are able to
%iterate through a list of strings!
pattern = {'noYFP', 'noLac', 'WT', 'RBS1', 'RBS1147', 'RBS1027', 'RBS446'};
phase_suffix = '_phase*.tif';
fitc_suffix = '_FITC*.tif';

%The associated function will read assemble the file names of each image
%and load the rest of the files. We'll call those images below. 

%Loop through all images and compute the mean intensities. 
for i=1:length(pattern)
    %We have to be careful about the auto fluorescence. Right now, we don't
    %know what the autofluorescence value is. However, this will be the
    %first thing that we actually calculate. Therefore, for the very first
    %image set, we will extract the mean autofluorescence without
    %subtracting any values. 
    if i==1
        [mean_ints(i), num_cells(i)] = baf(pattern(i), phase_suffix, fitc_suffix, 0.0);
    else
        %Now that we know what the autofluorescence value is, we can
        %subtract it from the rest of our measurements. 
        auto = mean(mean_ints(1));                                      
        [mean_ints(i), num_cells(i)] = baf(pattern(i), phase_suffix, fitc_suffix, auto);
    end
end

%Now this might take a while to run depending on your computer. As we are
%writing the rest of the script, we will break the rest of the analysis
%into another section. This section will be able to be run without having
%to rerun all of the image stuff. We can make a new section by adding two
%percentage signs (%%) on the next line. 
%%

%Now that we have all of the necessary information, let's go through and
%calculate the fold-change. In our experiment, the fold-change is the
%ratio of the fluorescence in the presence of repressor divided by the
%fluorescence in the absence of any repression. The second entry in our
%'mean_ints' vector is the no-repressor case. Computing fold change becomes
%very easy for us now!
fold_change = mean_ints ./ mean_ints(2);

%The first two values are meaning less to us. Let's get rid of them by
%truncating our fold-change vector. 
fold_change = fold_change(3:length(fold_change));

%Awesome! In class, we learned that without doing any experiments and doing
%a little bit of statistical mechanics, we can form a prediction of what
%the fold-change will look like as a function of number of repressors. In
%the spirit of physical biology, we'll plot the theory curve first and then
%add our points on top. We need to define a few theoretical parameters
%first. 
R = logspace(0, 5, 1000); %Number of repressors per cell. 
dEb = -14.1; %Difference in binding energy (in kT).
Nns = 5E6; %Approximate number of nonspecific binding sites. 

%Now we can generate the theory curve. 
fc_theory = (1 + (R ./ Nns) .* exp(-dEb)).^-1;

%Now let's plot it!
figure(1);
loglog(R, fc_theory, '-');
xlabel('number of repressors per cell');
ylabel('fold-change in gene expression');

%Now let's plot our experimental values on top. The number of repressors
%per cell can be determined through fluorescence microscopy but also
%through other methods such as quantitative western blotting and
%colorimetric assays. The number of repressors for each RBS mutant are
%given below. 
repressors = [10, 610, 30, 130, 62];

%Now let's plot it and see how well they agree!
hold on;
loglog(repressors, fold_change, 'o');
legend('theory', 'experiment');
hold off;

%That's a pretty fantastic aggreement! We have posted some information
%regarding the propagation of error on the course website. I urge you to
%try to take the above analysis and add some error bars. I hope that you
%have learned alot from the Matlab project!