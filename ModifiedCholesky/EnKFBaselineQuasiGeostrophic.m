clc;
clear all;
close all;
warning('off', 'all');

% Initialize variables
ens = 1000;
N = 40;
t = 12;
n = 10; % 127;
m = 10; % 127;
l = 1;
r = 3;
s = 1;
prop = 0.7;
dev = 0.01;

% Initialize model
model = QuasiGeostrophic(n, m, l, r, s);

% Derived variables
gridsize = n * m * l;
numobs = floor(prop * gridsize);

% Observation operator
H = sparse(numobs, gridsize);
obs = randperm(gridsize, numobs);
H(:, obs) = speye(numobs);

% Load ensemble and sample
data = load('SampleQG');

posx = 40;
posy = 40;
winx = posx:(posx + n - 1);
winy = posy:(posy + m - 1);
Xr = squeeze(data.Xr(1, winx, winy));
Xens = squeeze(data.Xens(randperm(ens, N), 1, winx, winy));

xr = grid2vec(Xr);
Xb = zeros(gridsize, N);
for i = 1:N
    Xb(:, i) = grid2vec(squeeze(Xens(i, :, :)));
end
y = H * xr + dev * randn(numobs, 1);
Xa = EnKF(y, Xb, H, dev, model);

mXb = mean(Xb, 2);
mXa = mean(Xa, 2);

erry = calcerror(y, H * xr);
errb = calcerror(mXb, xr);
erra = calcerror(mXa, xr);

display(erry);
display(errb);
display(erra);