%In this script, we will examine the probability of a chemoreceptor on a
%bacterium being active over a range of ligand concentrations. In the case
%of chemotaxis, the receptor is only active when the receptor is unbound.
%When bound with a particular ligand, a the receptor becomes inactive,
%resulting in the bacterium swimming forward. Methylation/demethylation of
%these receptors allows the bacterium to adapt to varying background levels
%of chemoattractant. This chemical modification effectively changes the
%active energy of the receptor. Let's pretend that we are making those
%chemical modifications.

%We'll start by defining some parameters.
e_a = [-10, -5, -1]; %active receptor binding energy (in kT).
e_i = 0; %inactive receptor binding energy (in kT).
deb_a = -5; %difference in energy of binding to active receptor (in kT).
deb_i = -10; %difference in energy of binding to inactive receptor (in kT).
L = logspace(-5, -1, 1000); %Range of ligand concentrations(in M). 

%Since we are interested in a range of active energies, we'll evaluate our
%function at each e_a through a for loop.
for i=1:length(e_a)
    %To save ourselves some typing, we can write the partition function
    %explicitly. 
    Z = exp(-e_a(i)) .* (1 + L.*exp(-deb_a)).^2 +... 
        exp(-e_i) .* (1 + L.*exp(-deb_i)).^2;

    %The above '...' breaks the long line into two shorter lines. This is 
    %to obey the good coding practice of keeping lines under 80 characters.

    %Now that we have the partition function, let's evaluate P_active. 
    p_active = exp(-e_a(i)) .*(1 + L.*exp(-deb_a)).^2 ./ Z;
    
    %Now we can plot it. We'll add a legend at each step through the
    %'DisplayName' argument of the plotting function. 
    semilogx(L, p_active, 'DisplayName',...
        ['\epsilon_a = ' num2str(e_a(i))     ' kT']);
    hold on;
end

%Most importantly...
xlabel('ligand concentration (M)');
ylabel('p_{active}');
legend('-DynamicLegend'); %Adds the DisplayNames as the legend entries.
hold off;

%The shifting of the curves demonstrates adaptation! Notice how the 'sweet
%spot' (inflection point) is always present, just at different points. This
%is how a bacterium can reverse direction over four orders of magnitude
%regarding ligand concentration. 
