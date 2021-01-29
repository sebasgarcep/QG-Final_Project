clc;
clear all;
close all;
warning('off', 'all');

% Initialize variables
ens = 1000;
N = 40;
t = 12;
n = 127;
m = 127;
l = 1;
ts = 0.1;
dev = 0.01;
wxs = 9;
wys = 9;

% Load ensemble and sample
data = load('SampleQG');

for r = 2:2
    for s = 1:1
        for prop = 0.7:0.7
            for iter = 1:1
                % Initialize model
                model = QuasiGeostrophic(n, m, l, r, s);

                % Derived variables
                gridsize = n * m * l;
                numobs = floor(prop * gridsize);
                nwx = floor(n / wxs);
                nwy = floor(m / wys);

                % Observation points
                Ho = sparse(n, m);
                obs = randperm(gridsize, numobs);
                Ho(obs) = 1;
                
                % Initialize data grids
                Xr = data.Xr(1:s, :, :);
                Xb = data.Xens(randperm(ens, N), 1:s, :, :);
                Ym = Xr + dev * randn(s, n, m);
                Xa = zeros(N, s, n, m);
                
                for wx = 1:nwx
                    for wy = 1:nwy
                        display(['* Computing (', num2str(wx), ',', num2str(wy), ')']);
                        
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
                        
                        assimlenx = xf - xi + 1;
                        assimleny = yf - yi + 1;
                        winlenx = ubx - lbx + 1;
                        winleny = uby - lby + 1;
                        winsize = winlenx * winleny;
                        
                        % Vectorize observation operator
                        winMask = Ho(lbx:ubx, lby:uby);
                        winobs = winMask .* vec2grid(1:winsize, winlenx, winleny);
                        winobs = grid2vec(winobs);
                        winobs = winobs(winobs > 0);
                        [numwinobs, ~] = size(winobs);
                        vecH = sparse(numwinobs, winsize);
                        vecH(:, winobs) = speye(numwinobs);
                        
                        % Vectorize our grid for the algorithm
                        vecXb = zeros(s * winsize, N);
                        vecy = zeros(s * winsize, 1);
                        for k = 1:s
                            idx = (1 + (k - 1) * winsize):(k * winsize);
                            vecy(idx, 1) = grid2vec(squeeze(Ym(k, lbx:ubx, lby:uby)));
                            for e = 1:N
                                vecXb(idx, e) = grid2vec(squeeze(Xb(e, k, lbx:ubx, lby:uby)));
                            end
                        end
                        vecy = vecH * vecy;
                        
                        vecXa = ModifiedCholesky(vecy, vecXb, vecH, ts, dev, model);
                        
                        % Integrate vecXa into Xa
                        for e = 1:N
                            for k = 1:s
                                idx = (1 + (k - 1) * winsize):(k * winsize);
                                kXa = vec2grid(vecXa(idx, e), winlenx, winleny);
                                rangex = (1 + xi - lbx):(winlenx + xf - ubx);
                                rangey = (1 + yi - lby):(winleny + yf - uby);
                                Xa(e, k, xi:xf, yi:yf) = kXa(rangex, rangey);
                            end
                        end
                    end
                end
                
                dataXr = Xr(:);
                mXb = mean(Xb, 1);
                dataXb = squeeze(mXb);
                dataXb = dataXb(:);
                dataY = Ym(:);
                mXa = mean(Xa, 1);
                dataXa = squeeze(mXa);
                dataXa = dataXa(:);
                
                erry = calcerror(dataY, dataXr);
                errb = calcerror(dataXb, dataXr);
                erra = calcerror(dataXa, dataXr);
                
                display(erry);
                display(errb);
                display(erra);
            end
        end
    end
end
