function fc = fc( R, epsilon )
% Returns the theoretical fold change for a simple repession architecture
% Parameter
% ---------
% R: float.
%   Number of repressors per cell.
% epsilon: float.
%   Repressor binding energy
%fc = 1 / (1 + 2 * R / 4.6E6 * exp(-epsilon));
fc = arrayfun(@(r) 1 / (1 + 2 * r / 4.6E6 * exp(-epsilon)), R);

end