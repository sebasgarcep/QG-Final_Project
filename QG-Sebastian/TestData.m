clc;
clear all;
close all;

data = load('experiment.mat');

real = data.real;
ens = data.ens;
y = data.y;

gridsize = 127 ^ 2;

for k = 1:12
    display(['Time slot t = ', num2str(k)]);
    
    idx = (1 + (k - 1) * gridsize):(k * gridsize);
    
    my = y(idx);
    mr = real(idx);
    
    display(['Error of observation: ', num2str(norm(my - mr))]);
    
    mx = mean(ens(idx, :), 2);

    display(['Error of ensemble: ', num2str(norm(mx - mr))]);
end
        