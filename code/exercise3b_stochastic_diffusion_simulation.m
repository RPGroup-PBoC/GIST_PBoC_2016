%This script will simulate diffusion of a particle over time. While we can
%solve the diffusion equation analytically, this will serve as a fun way to
%learn how to write stochastic simulations. As we are writing a simulation,
%I am going to include two commands that will reset the variables and plots
%each time that the simulation is run. 
clear all %Resets all variables.
close all %Get's rid of all of the figures. 

%We will begin by considering
%the diffusion of a single particle in one dimension. We will say that at
%any point in time, the particle has an equal probability taking a step to
%the left as it can take a step to the right. Let's take a look at the
%trajectory of a single walker.

%plot y axis distance from origin
rng(42); %Sets a seed for the random number. This will make your plots reproducible 
n_steps = 1000; %Number of steps the simulation will run. Try changing this!
p = 0.5; %Probability of stepping to the right.

%We can simulate the random walk by flipping a coin at each step and
%testing its value with the probability. Let's give it a shot. 

position = 0; %We'll start the particle at the origin. 
for i=1:n_steps;
    %Flip a coin. 
    flip = rand(); %Generates a random number between 0 and 1. 
    
    %Now test what the value is. 
    if p < 0.5; 
        position = position + 1;
    else
        position = position - 1;
    end %Ends our determination of the coin flip. 
    
    %Now we want to store where our particle is at each step. 
    displacement(i) = position;

    %And that's it!
end

%Now we can plot the trajectory as a function of time (step number) and see
%where it went. 
time = 1:1:n_steps; %Time vector. 
plot(time, displacement);
xlabel('time (number of steps)');
ylabel('position');

%Now we can see where our walker went. It's not very useful to see where a
%single particle diffused. Let's up our number of walkers to something
%huge. That will be representative of the behavior of our system. Let's
%modify our above for loop to do this. 
n_simulations = 1000;
for i=1:n_simulations
    %Now we want to reset our position for each simulation. 
    position = 0;
    for j=1:n_steps
        %Generate our coin flip and decide where to go. 
        flip = rand();
        if flip < p
            position = position + 1;
        else
            position = position - 1;
        end
        
        %Now we will record our position at each time point. 
        displacement(j) = position;
    end %The end of each simulation. 
    %Now we want to plot the position of each walker at the end of the
    %simulation. 
    plot(time, displacement);
    hold on %Tell Matlab to wait while we plot more trajectories. 
    
    %Now we just have to end the whole loop. 
end

%Tell Matlab to stop plotting. 
hold off
xlabel('time (number of steps)');
ylabel('position');

%Cool! Now we can see all sorts of cool trajectories. Let's take a look at
%the distribution of ending positions. This means that we need to keep
%track of one last thing on our loop. While we could make the change above,
%we'll just copy and paste the above loop and make the changes below. 
for i=1:n_simulations
    %Now we want to reset our position for each simulation. 
    position = 0;
    for j=1:n_steps
        %Generate our coin flip and decide where to go. 
        flip = rand();
        if flip < p
            position = position + 1;
        else
            position = position - 1;
        end
        
        %Now we will record our position at each time point. 
        displacement(j) = position;
    end %The end of each simulation. 
    
    %Make a vector to store the end position of each simulation.
    final_position(i) = position;
end

%Now let's plot the distribution of final positions. 
hist(final_position, 100); %Generates a histogram. 
xlabel('position');
ylabel('frequency');


%Now we can see on average how far the particles diffuse at specific step
%numbers. Let's see how the displacement would change as a function of step
%number. In our simulation, we are storing positions that are both positive
%and negative. If we wanted to get an idea of the average distance
%traveled, we can simply square the final position and take the average of
%all of the simulations. This means that we need one more layer to our for
%loop as well as redifine our number of steps. 
n_steps = logspace(1, 4, 5); %Space numbers logarithmically. 

for k=1:length(n_steps)
    for i=1:n_simulations
    %Now we want to reset our position for each simulation. 
    position = 0;
    for j=1:n_steps(k)
        %Generate our coin flip and decide where to go. 
        flip = rand();
        if flip < p
            position = position + 1;
        else
            position = position - 1;
        end
        
        %Now we will record our position at each time point. 
        displacement(j) = position;
    end %The end of each simulation. 
    
    %Make a vector to store the end position of each simulation.
    final_position(i) = position;
    end

    %Now we just have to generate a vector to save the mean square
    %displacement.
    msd(k) = mean(final_position.^2);
end

%It's that easy. Let's look at how it scales with time. 
loglog(n_steps, msd, 'o-'); %log log is better for this scale. 
xlabel('time');
ylabel('mean squared displacement');


