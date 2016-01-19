function logpost = log_post( epsilon, R_arr, fc_arr )
%Computes the log posterior for a single set of parameters assuming a
%uniform prior and a Gaussian likelihood. The variance of the Gaussian
%likelihood was integrated out giving a Student-t distribution.
% Parameter
% ---------
% R_arr: float array.
%   Number of repressors.
% epsilon: float.
%   Binding energy.
% fc_arr: float array.
%   Experimental fold change measured for those given values of repressors.
fc_theory = fc(R_arr, epsilon);
logpost = - length(fc_arr) / 2 * log(sum((fc_arr - fc_theory).^2));

end

