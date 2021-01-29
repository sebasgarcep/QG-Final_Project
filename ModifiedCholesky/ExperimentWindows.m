clc;
clear all;
close all;
warning('off', 'all');

% Initialize variables
N = 40;
t = 12;
n = 127;
m = 127;
l = 1;
ts = 0.1;
dev = 0.01;
wxs = 9;
wys = 9;

% Derived variables
gridsize = n * m * l;
nwx = floor(n / wxs);
nwy = floor(m / wys);

% load ensembles
data = load('experiment.mat');
Xr = data.real';
Xens = data.ens';
y = data.y';

for r = 2:2
    for s = 3:3
        for prop = 1:1
            for i = 1:1
                filename = ['results/', 'i', num2str(i), 'r', num2str(r), 's', num2str(s), 'prop', num2str(prop), '.mat'];
                Xb = Xens(:, randperm(1000, N));
                Xa = zeros(t * gridsize, N);
                
                for wx = 1:nwx
                    for wy = 1:nwy
                        xi = 1 + wxs * (wx - 1);
                        yi = 1 + wys * (wy - 1);
                        
                        if wx < nwx
                            xf = xi + wxs - 1;
                        else
                            xf = n;
                        end
                        
                        if wy < nwy
                            yf = yi + wys - 1;
                        else
                            yf = m;
                        end
                        
                        lbx = max(xi - r, 1);
                        lby = max(yi - r, 1);
                        ubx = min(xf + r, n);
                        uby = min(yf + r, m);
                        
                        W = window(n, m, lbx, lby, ubx, uby);
                        W = repmat(W, t, 1);

                        winXr = real(W == 1);
                        winy = y(W == 1);
                        winXb = Xb(W == 1, :);
                        
                        wn = ubx - lbx + 1;
                        wm = uby - lby + 1;
                        
                        winXa = ModifiedCholesky(winy, winXb, N, t, wn, wm, l, r, s, ts, dev, prop);
                        
                        subxi = 1 + (xi - lbx);
                        subyi = 1 + (yi - lby);
                        subxf = wn + (xf - ubx);
                        subyf = wm + (yf - uby);
                        subW = window(wn, wm, subxi, subyi, subxf, subyf);
                        subW = repmat(subW, t, 1);
                        
                        subwinXa = winXa(subW == 1, :);
                        
                        assimW = window(n, m, xi, yi, xf, yf);
                        assimW = repmat(assimW, t, 1);
                        
                        Xa(assimW == 1, :) = subwinXa;
                        
                        display([wx wy]);
                    end
                    
                    meanXb = mean(Xb, 2);
                    meanXa = mean(Xa, 2);
                    
                    errb = error(meanXb, Xr);
                    erry = error(y, Xr);
                    erra = error(meanXa, Xr);
                    
                    save(filename, 'errb', 'erry', 'erra');
                end
            end
        end
    end
end