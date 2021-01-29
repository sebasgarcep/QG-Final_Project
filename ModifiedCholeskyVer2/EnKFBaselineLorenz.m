clc;
clear all;
close all;
warning('off', 'all');

% Initialize variables
ens = 1000;
N = 80;
t = 12;
prop = 0.7;
dev = 0.01;
f = 40;
T = [0 0.3];

% Derived variables
numobs = floor(prop * f);

% Observation operator
H = sparse(numobs, f);
obs = randperm(f, numobs);
H(:, obs) = speye(numobs);

% Initialize Model
model = Lorenz96(f);

% Load ensembles
data = load('SampleLorenz');

xr = data.xt;
Xens = data.XB;

% Sample from the ensemble
Xb = Xens(:, randperm(ens, N));

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