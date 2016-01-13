%This script will demonstrate the usefulness of using the taylor expansion
%to approximate the local shape of a curve. We will look at a simple
%function, y = cos(x), but it may be useful for you to try more complicated
%functions.

%We'll start by making a range of x values at which to evaluate cos(x)

%Make a range of x values and evaluate cos(x). 
x = -4*pi:.01:4*pi;
y = cos(x);

%Now let's evaluate the first handful of orders. 
order_0 = ones(size(x)); %Makes an array of 1s.
order_2 = 1 - x.^2/factorial(2); %Second order expansion
order_4 = order_2 + x.^4/factorial(4); %Fourth order expansion
order_6 = order_4 - x.^6/factorial(6); %Sixth order expansion

%Now we'll plot all of these orders and add a legend. 
plot(x,y,'b-');
hold on
plot(x, order_0);
plot(x, order_2);
plot(x, order_4);
plot(x, order_6);
%Now add a legend so we know what is what. 
legend('cos(x)', '0th', '2nd', '4th', '6th');
xlabel('x');
ylabel('y');
%We'll change the limits of y so it is easier to see. 
ylim([-1 1]);
hold off

%With this, we can see that even the first few expansions are a great
%approximation of the actual behavior. 