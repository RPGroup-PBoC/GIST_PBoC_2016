%This script will perform a numerical integration of simple mRNA decay
%dynamics. We will consider the case of an unregulated, constitutively
%expressed gene. For this simple system, the differential equation is
%
%  dm/dt = r - y*m
%
% where r is the production rate of mRNA, y is the degradation rate, and m
% is the number of mRNA molecules. Our integration is rather simple, but
% first let's define a few parameters and look at each components
% contribution to dm/dt.   
r = 1; % mRNA production in 1/min.
y = 1/3; %mRNA decay in 1/min.

%We'll evaluate this at a range of mRNAs per cell. 
m = 0:1:10; %mRNA per cell.

%The production rate is constant as it is independent of m. This means that
%if we wish to plot the production, it will simply be a vector of the same
%number repeated for each mRNA level. 
production = (ones(size(m)) .* r);

%The decay is very simple to compute as well. 
decay = y.*m;

%Now let's plot it!
figure(1);
plot(m, production);
hold on;
plot(m, decay);
legend('production component', 'degradation component');
xlabel('mRNA per cell');
ylabel('contribution to dm/dt');
hold off;

%The stable fixed point is where the two lines intersect. This value is the
%r/y, as was described in class. Now that we have an idea of what each
%component contributes to dm/dt, let's do the integration. We will start
%by defining some parameters for our integration. 
%Now define paramters for our integration. 
total_time = 10; %in units of min. 
dt = 0.1; %Time step in units of min. 
time_steps = total_time / dt; %unitless! Number of steps to take. 

%We want to make a vector to keep track of the number of mRNA molecules at
%each step. We'll make our initial condition 0.
m_t = zeros(1, time_steps);

%Can change the initial condition to something huge. 
initial_condition = [0 10];

%Now we can do the integration! We will want to plot the result for each
%inital condition, so we first need to make a time vector. 
time = (1:1:time_steps) .* dt; %To convert it to min. 
figure(2)
for i=1:length(initial_condition);
    %We will set the initial condition for each simulation.
    m_t(1) = initial_condition(i);
    for j=2:length(m_t);
        %Now we just have to compute m_t at each time step! 
        m_t(j) = m_t(j-1) + r*dt - y*m_t(j-1)*dt;
    end
    %It's that easy. 
    plot(time, m_t);
    hold on;
end

%We can mark where our stable point is by drawing a horizontal line at that
%position. 
m_star = (ones(1,time_steps) .* (r/y)); 
plot(time, m_star);

%Most importantly...
legend('m(0) = 0', 'm(0) = 10', 'm*');
xlabel('time (min)');
ylabel('m(t)');
hold off;

%We can see that it pretty rapidly converges to the stable fixed point of
%r/y.
