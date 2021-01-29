clc;
clear all;
close all;

% RK parameters
T = [0 0.05];

% Ensemble size
N = 20;

% Problem Size
n = 40;

% The observations and model state exist in the same space. Then the
% observation matrix is the identity.
H = eye(n);
R = eye(n);
C = eye(n);

% Generate corresponding numerical models for the simulation and reality.
M = Lorenz96(8);

% First, generate an initial ensemble which we will assume is a true
% estimate of reality. Both the model and the reality must propagate this
% forward in time.
Data = load('SampleLorenz');
per = randperm(1000, N);
X = Data.XB(:, per);
Y = Data.xt;

% Assimilation parameters
max_iter = 50;
epsilon = 1e-4;
tol = 1e-3;
lambda = 0;
U = eye(N, N);
L = 8;
beta = ones(L, 1);

% Filter = EnsembleKalmanFilter();
% Filter = IterativeEnsembleKalmanFilter(max_iter, epsilon, tol, lambda, U);
% Filter = SDAIterativeEnsembleKalmanSmoother(max_iter, epsilon, tol, lambda, U, L);
% Filter = SDAIterativeEnsembleKalmanSmootherN(max_iter, epsilon, tol, lambda, U, L);
Filter = MDAIterativeEnsembleKalmanSmoother(max_iter, epsilon, tol, lambda, U, L, beta);

for i = 1:100
    Y = M.propagate(Y, T);
    
    XP = Filter.update(X, C, Y, R, H, M, T);
    
    % Measure error quantities.
    EB = mean(X, 2) - Y;
    display(norm(EB));

    EA = mean(XP, 2) - Y;
    display(norm(EA));
    
    X = XP;
end

