function [newc,dcc] = Getdcoverc(tau,L,c)
% Get equivaent phase velocity and phase velocity perturbation
% corresponding to a time delay experienced over a lengthscale

newc = L/(L/c + tau);
dcc = 100*(newc-c)/c;

end