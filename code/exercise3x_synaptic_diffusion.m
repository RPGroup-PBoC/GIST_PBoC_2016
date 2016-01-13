% How long does it take a neurotransmitter to diffuse across a synaptic
% cleft? We can model the synapse as a box with a reflective barrier
% (transmitting neuron) and an absorptive barrier (receptor). In our model,
% the neurotransmitter can't travel past either barrier. If  it is at the
% reflective barrier, it can only travel forward one step size. If it is at
% the absorbing barrier, the walk is over. We don't know a priori how many
% steps it will take to hit the barrier, so we need to keep track of where
% the particle is at each individual step. Let's begin by defining a few
% parameters.
position = 0; %Initial position of the molecule.
step_number = 1; %Our first step. 
length = 10; %Length of the synapse. 

%Our simulation will end when we hit the receptive barrier. We don't know
%how many steps it will take to hit the receptor. We will use another type
%of loop, a while loop, which will repeat until a specific condition is
%met. Let's first initialize the number of steps needed. 
steps_needed = 0;

%Now we can do the loop.
while steps_needed == 0
    
    %We need to check whether we are at zero or not (our reflective barrier).
    if position ==0 %In MATLAB, == is a logic test.
        position = position + 1;
        step_number = step_number + 1; %Updates the number of steps we have taken. 
    elseif position==length 
        %This tests if we are at the receptor barrier. The simulation would
        %stop at this point. If it hits this position, we'll record the step
        %number.
        steps_needed = step_number;
    else
        %If neither of these conditions are met, we will flip a coin and decide
        %which direction we need to step.
        random_number = rand;
        if random_number < 0.5
            position = position - 1; %Update the position.
            step_number = step_number + 1; %Save the step number. 
        else 
            position = position + 1;
            step_number = step_number + 1;
        end %Ends the coin flip.
    end %Ends the first cycle of the loop.
end %Ends the entire simulation.

steps_needed %Everytime we run this simulation this number will vary!

%To get a good measure of the how long on average, we should run the loop
%many times and get a distribution. We can put this in another loop to run
%the whole simulation a large number of times. 

length = 10;
n_simulations = 5000; %Number of times we will run. 
for i=1:n_simulations
    
    steps_needed(i) = 0; %We should reset this for each simulation.
    position = 0; %Same with this.
    step_number = 0; %And this.
    
    while steps_needed(i) == 0

        %We need to check whether we are at zero or not (our reflective barrier).
        if position ==0 %In MATLAB, == is a logic test.
            position = position + 1;
            step_number = step_number + 1; %Updates the number of steps we have taken. 
            
        elseif position==length 
            %This tests if we are at the receptor barrier. The simulation would
            %stop at this point. If it hits this position, we'll record the step
            %number.
            steps_needed(i) = step_number;
            
        else
            %If neither of these conditions are met, we will flip a coin and decide
            %which direction we need to step.
            random_number = rand;
            
            if random_number < 0.5
                position = position - 1; %Update the position.
                step_number = step_number + 1; %Save the step number. 
                
            else 
                position = position + 1;
                step_number = step_number + 1;
                
            end %Ends the coin flip.
        end %Ends the first cycle of the loop.
    end %Ends the ith simulation.
end %Ends the entire simulation.

%Let's calculate the average number of steps needed.
mean(steps_needed) %Around 100 each time!


%Let's look at a histogram of these values. We can use MATLABs 'hist'
%function to generate a histogram of the values. 
hist(steps_needed, 100)

%It's always important to label the axes.
xlabel('Waiting time');
ylabel('Number');