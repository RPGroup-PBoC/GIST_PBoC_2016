n_steps = 1000;
n_simulations = 100;
p = 0.4;

time = 1:1:n_steps;
for i=1:n_simulations;
    position = 0;
    for j=1:n_steps;
        flip = rand();
        if flip < p;
        position = position + 1;
        else
            position = position - 1;
        end
        displacement(j) = position;
    end
    plot(time, displacement);
    hold on
end
xlabel('time');
ylabel('position');
hold off;