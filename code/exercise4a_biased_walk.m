%This script will perform a stochastic 'random' walk with a varying degree
%of bias in the probability of taking a step. In our previous simulations,
%we have asserted that the probability of taking a step to the left or to
%the right is equal. This yields a random direction of motion. However,
%even if we mildy change the bias in the coin flip. we can get something
%that is very reminiscent of directed motion. But let's prove it to
%ourselves! We'll start by defining some parameters. 
n_steps = 1000;
n_simulations = 100;
p = [0.5, 0.55, 0.6, 0.9]; %Bias of coin flips.  

%We will want to plot all of the trajectories, so we'll just make our time
%vector now. 
time = 1:1:n_steps;

%For this simulation, we will want to iterate through each probability,
%simulation, and step. This will have to be a three-layered for loop.
for i=1:length(p); 
    for j=1:n_simulations;
        %We want to mark our initial position for each simulation.
        position = 0;
        for k=1:n_steps;
            %Do a coin flip. 
            flip = rand();
        
            %Now test if that coin flip makes us step right or left. 
            if flip < p(i);
                position = position + 1;
            else
                position = position - 1; 
            end
        
            %Now we just have to store the displacement at each step.
            displacement(k) = position;
        end
    
      %We will set this up so our plot is actually a single figure with
      %separate axes. This is called a 'subplot' and is a useful way of
      %displaying different plots at once. 
      subplot(length(p),1,i);
      
      %The above syntax can be a little confusing. This means that a
      %subplot with the same number of axes as the number of values of p
      %will be generated in a single column. For each value of p (our index
      %'i'), we will plot our trajectories on that specific axis. 
      plot(time, displacement);
      title(['p =' num2str(p(i))]); %Add a title so we know what is what. 
                                %'str' makes our variable a string. 
      ylabel('position'); %We'll add the ylabel here for each plot. 
    hold on;
    end
end

%Now that we have run our simulation, let's label our plot and take a
%look!
xlabel('time (number of steps)');
hold off
    
