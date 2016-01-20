%Here I will simulate a random walk in 2D using parameters relavent to a 1
%um bead with deltaX ~ sqrt(2*D*deltat). I will also consider that the bead
%is in a potential well (i.e. optical tweezer) with potential well profile
%given by -(1/2) * K * x^2 . Note that this 'spring' force is in balance
%with the stokes drag for a bead of radius a (6 pi eta a delta x/ delta t).

%Run3 -> lets look at one simulation of the bead in a potential well.

close all
clear all

%Lets define some parameters for simulation

n_steps = 300;
n_simulations = 1;
position_x = zeros(1,n_steps); %track changes in position after each step
position_y = zeros(1,n_steps);
final_pos_x = zeros(1,n_simulations); %take note of last position
final_pos_y = zeros(1,n_simulations);

%some parameters for the simulation
KbT = (4/1000);                 % in pN/micron (KbT ~ 0.004 pN micron)
a = 1 ;                         % bead size in micron
eta = 10^-3 ;                   % water vicosity
D = KbT / (6 * pi * eta * a) ;  % Diffusion constant
deltat = 0.001 ;                % 1 msec time steps
K = 10;                         % pN/um

%lets simulate a random walk in 2D, where each time step we move on average
%sqrt(2*D*deltat) but with some fluctuations around this which will be
%given by a gaussian function (use MATLAB's function randn(1).

for i = 1:n_simulations
    % Now we want to reset our position for each simulation. 
    position_x = 0;
    position_y = 0;
    
    for j = 2:n_steps %2 since position at time zero = 0,0 (X,Y)
        %Lets treat X and Y as independent and allow them to move 
        %deltax = sqrt(2*D*deltat) in timestep deltat
        %we multiple this term by a normally distributed random number with
        %mean and std. dev = 1 since this is a 'noisy' process and each
        %time step will not be exacted equal to sqrt(2 * D * deltat).
        
        %I will also consider that the bead
        %is in a potential well (i.e. optical tweezer) with potential well profile
        %given by -(1/2) * K * x^2 . Note that this 'spring' force is in balance
        %with the stokes drag for a bead of radius a (6 pi eta a delta x/ delta t)
        
        position_x(j) = position_x(j-1) + randn(1) * sqrt(2 * D * deltat) -...
                         (K / (6 * pi * eta * a)) * position_x(j-1) * deltat;
        position_y(j) = position_y(j-1) + randn(1) * sqrt(2 * D * deltat) -...
                         (K / (6 * pi * eta * a)) * position_y(j-1) * deltat;
        
        %lets plot this and watch the progression over time. Remember that
        %we expect the distance 'explored' after time t ~ sqrt(2 * D * t)
        % We still have a random walk - but now t is more confined and
        % dependent on the spring constant - so over time the mean square
        % displacement doesn't increase - right?
        plot(position_x(1:j) , position_y(1:j), 'Color', 'k')
        xlim([-0.5 0.5]) % microns
        ylim([-0.5 0.5]) % microns
        xlabel('X position (microns)')
        ylabel('Y position (microns)')
        set(gca,'FontSize',18);
        hold on
        pause(0.05)
        
        %end step j for simulation i
    end
    
        
        %lets take note of the mean square displacement
        final_pos_x(i) = position_x(n_steps); %take note of last position
        final_pos_y(i) = position_y(n_steps); 


    %end simulations
end

% mean square distance
msd_x = sqrt(mean(final_pos_x.^2));
msd_y = sqrt(mean(final_pos_y.^2));

%how does the MSD compare to what we'd expect for an optical tweezer.
%msd_i = KBT/ k_trap
%it should be pretty close, right?


        
    
