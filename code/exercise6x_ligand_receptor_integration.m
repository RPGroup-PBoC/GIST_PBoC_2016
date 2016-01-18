%This script will numerically integrate the probability of a receptor being
%bound by a ligand as a function of time. While the solution can be
%computed analytically, this will be a good example of how to perform this
%numerical approximation. We'll begin by defining a number of variables.
K_on = 0.001; %On rate ligand binding to receptor in s^-1.
K_off = [0.001, 0.002, 0.004, 0.008, 0.016]; %Range of dissociation constants (in s^-1).

%Now we want to store the value at which the receptors are saturated with
%ligand (when Pbound is maximal). To do this for each dissociation constant,
%we'll create an empty vector to which we will add the value. 
saturation_value = zeros(1, length(K_off)); 

%Now we are ready to perform the numberical integration. Since we'll be
%cycling the range of K_off, we'll need two layers in the for loop.
%We have two more parameters we need to define for the integration -- the
%time step and the total length of the integration. 
dt = 0.01 / (K_on + min(K_off)); %Time step
time = 0:dt:500*dt; %From 0 to 500 time steps, taking steps of one time step.

%Now, we can start the integration!
for i=1:length(K_off) %Cycling through each value of K_off.
    %We should generate a vector to which we will keep track of the value
    %of Pbound at each time step. 
    P_bound = zeros(1, length(time)); %A 1D vector with zeros.
    
    %Now we will compute the value of Pbound at each time step. We will say
    %that at the first time point (t=0), the probability of being bound is
    %0.
    for j=2:length(time)
        %First compute the change in P_bound. 
        dP_bound = (1 - P_bound(j-1)) * K_on * dt...
            - P_bound(j-1) * K_off(i) * dt;
        %Now that we computed the change in the probability, we can simply
        %add it to the P_bound value from the previous time step.
        P_bound(j) = P_bound(j-1) + dP_bound;
    end %End the loop through the time steps. 
    %Now we can store the saturating value of P_bound.
    saturation_value(i) = max(P_bound);
    %We should plot the trajectory of P_bound at each value of K_off. We
    %can do this in the middle of the loop!
    figure(1) %Generate a new figure.
    plot(time, P_bound, '-'); %Plot the trajectory as a line.
    hold on%Allow other plots to be made on the same set of axes.
    
    %We are finished!
end
hold off;
%Most importantly, we need to add labels and a legend to our plots.
xlabel('time (s)');
ylabel('P_{bound}');
%Add a legend for each value of K_off. 
legend('K_{off} = 0.001', 'K_{off} = 0.002', 'K_{off} = 0.004',...
    'K_{off} = 0.008', 'K_{off} = 0.016');

%Cool! We can see that the larger the value of K_off, the lower the
%saturating value of P_bound. Let's take a look at how this saturation
%value changes with a change in K_off. 
figure(2)
plot(K_off, saturation_value, 'ko'); %As black circles.
xlabel('K_{off} (s^{-1})');
ylabel('Saturation P_{bound}');