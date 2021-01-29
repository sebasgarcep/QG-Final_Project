clc;
clear all;
close all;

data = load('experiment');

Xr = zeros(12, 127, 127);
Xens = zeros(1000, 12, 127, 127);

gridsize = 127 * 127;

for t = 1:12
    idx = (1 + (t - 1) * gridsize):(t * gridsize);
    
    Xr(t, :, :) = vec2grid(data.real(idx, 1), 127, 127);
    
    for e = 1:1000
        Xens(e, t, :, :) = vec2grid(data.ens(idx, e), 127, 127);
    end
end

save SampleQG Xr Xens;