clc;
clear all;
close all;
warning('off', 'all');

data = load('SampleQG');
results = load('Propagation');

t = 12;
LXr = data.Xr;
numitems = results.numitems;

for idx = 1:numitems
    display(['* Experiment # ', num2str(idx)]);
    
    LXb = squeeze(results.LXb(idx, :, :, :));
    LXa = squeeze(results.LXa(idx, :, :, :));
    
    RMSEb = 0;
    RMSEa = 0;
    
    for k = 1:t
        Xr = squeeze(LXr(k, :, :));
        xr = Xr(:);
        
        Xb = squeeze(LXb(k, :, :));
        xb = Xb(:);
        epsb = sqrt((xb - xr)' * (xb - xr));
        RMSEb = RMSEb + epsb ^ 2;
        
        % display(epsb);
        
        Xa = squeeze(LXa(k, :, :));
        xa = Xa(:);
        epsa = sqrt((xa - xr)' * (xa - xr));
        RMSEa = RMSEa + epsa ^ 2;
        
        % display(epsa);
    end
    
    RMSEb = sqrt(RMSEb / t);
    RMSEa = sqrt(RMSEa / t);
    
    display(RMSEb);
    display(RMSEa);
end