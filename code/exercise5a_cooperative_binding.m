%In this script, we will consider a receptor which can bind two ligands.
%Using the statistical mechanics we learned in lecture, we can enumerate
%these states, figure out the multiplicity, and compute their statistical
%weights. How does the probability of each state change with a
%concentration of ligand? Let's find out!

%We'll start by declaring some variables. 
d_eb = -5; %Energy difference between bound and unbound state (in kT). 
d_ei = -2; %energy of interaction (in kT). 
L = logspace(-4, -1, 1000); %Range of ligand concentrations (in M). 

%To save our fingers some work, we'll define the partition function. 
Z = 1 + 2 .* L .* exp(-d_eb) + L.^2 .* exp(-(2*d_eb + d_ei));

%Now we'll compute the probability of each state.
p_empty = 1 ./ Z;  %Nothing bound -- empty receptor. 
p_one = L * exp(-d_eb) ./ Z; %Probability of one ligand being bound.
p_both = L.^2 .* exp(-(2 * d_eb + d_ei)) ./ Z; %Probability of both.

%Now plot the probabilities as a function of ligand concentration. 
figure(1) %This makes a new figure window.
semilogx(L, p_empty);
hold on;
semilogx(L, p_one);
semilogx(L, p_both);

%Now the most important part.
xlabel('ligand concentration');
ylabel('probability of state');
legend('Empty', 'Singly Bound', 'Doubly Bound', 'Anything bound');
hold off

%There is a lot of interesting stuff going on here. We can see that with a
%high concentration of ligand, the most common state is having both bound
%at once. In the middle of the range, empty and doubly bound are equal with
%a singly bound state less probably. Let's now compute the average number
%of bound ligands as a function of concentration.

%Since we have already enumerated our probabilities, the calculation is
%trivial.
n_bound = 2 * p_one + 2 * p_both;

%Now let's plot it. 
figure(2)
plot(L, n_bound, 'k-');
xlabel('ligand concentration (M)');
ylabel('average number of bound ligands');

%Now, go back and try changing the energy of interaction and see how the
%curves change!