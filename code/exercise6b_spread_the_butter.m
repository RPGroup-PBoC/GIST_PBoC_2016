%In this script, we will do a numerical integration of a more complex issue
%- the distribution of mRNAs as a function of time. Our differential
%equation is 
%
% dP(m,t)/dt = rp(m-1,t) + y*(m+1)*p(m+1,t) - rp(m,t) -ymp(m,t)
%
% where m is the number of mRNAs, t is timepoint t, r is the production
% rate of mRNA, y is the decay rate of mRNA, and P(m,t) is the probability
% of m mRNAs at time t. We'll start our integration by first defining a few
% parameters. 
r = 1; %In units of 1/min.
y = 1/3; %in units of 1/min;
dt = 0.05; %in units of min;
total_time = 5; %in min. 
time_steps = total_time/dt; %Total number of time steps for the integration. 

%We should look at a range of mRNA numbers. We know that our system should
%converge to the stable fixed point, r/y. 
num_rna = 20;

%We want to save the probability of each mRNA copy number as a function of
%time. This means that we can make a two-dimensional array in which row
%represents a number of mRNAs per cell and each column represents a time
%step. To start, we'll populate them with 0's. 
p = zeros(num_rna + 1, time_steps);

%Now we can set our initial position. We will start by saying at time 0,
%there are 0 mRNA molecules. This means that at p(1,1), the value is 1.0.
p(1,1) = 1;

%Now we have everything set for our integration. Since we have set our
%initial condition, we will compute the probabilites for the rest of the
%possible mRNA molecules at each time step. 

for t=2:time_steps
    %We want to loop through each possible mRNA molecule. 
    for m=1:num_rna
        p(m,t) = p(m, t-1) + y*dt*(m+1)*p(m+1,t-1) - r*dt*p(m, t-1)...
            -y*dt*m*p(m, t-1);
         %Now it is a simple plug-n-chug. We have to keep in mind that if we
        %have 0 mRNAs [p(1, t)], we do not need to add in the production
        %term from the m-1 state. We will do that with an if statement. 
        if m > 1
            %If we have more than 0 mRNAs, add in the following term.
            p(m,t) = p(m,t) + r*dt*p(m-1, t-1);
        end
        %And that is it! 
    end
end

%Now we can  plot it and see how the integration worked. If things went
%according to plan, then it should converge to a mean of r/y mRNA
%molecules. 
bar3(p) %This will generate a 3D bar plot. 
xlabel('time in time steps');
ylabel('number of mRNA');
zlabel('Probability');

%Once this is plotted, try rotating the plot around to get a better view at
%what is happening. 


