clc
clear all
close all

global n P

%RK parameters
T = [0 0.3]; 

%Model dimension
n = 40;

%Model parameters
P.F = 8;

%Ensemble size
N = 80;

%Observations
p = .7;
m = floor(n*p);
erro = .01;

L = load('SampleLorenz');

[U,S,V] = svd(L.XB',0);

% fig = figure;
% plot(U(:,1),U(:,2),'*');
% 
% fig = figure;
% histogram2(U(:,1),U(:,2));

per = randperm(1000,N);

XB = L.XB(:,per);
xt = L.xt;

%1. Forecast
for i = 1:N
XB(:,i) = propagate_model(XB(:,i),T);
end
xt = propagate_model(xt,T);

%1.1 Ensemble mean 
xmb = mean(XB,2);

%1.2 Ensemble covariance (Background error covariance)
Sb = XB-xmb*ones(1,N);
Pb = (1/(N-1))*Sb*Sb';

%2. Analysis

%% Observation information - sensors, land station (UNKNOWN STAT)
obs = randperm(n,m);
H = sparse(m,n);
H(:,obs) = eye(m,m);
y = H*xt+erro*randn(m,1);
%%

%We build this with observation info
Ys = y*ones(1,N)+erro*randn(m,N); %Synthetic observations

%Analsys step

%1. Analysis covariance (precision)
Ainv = inv(Pb)+(1/erro^2)*(H'*H);

%2. Analysis ensemble
XA = XB+Ainv\((1/erro^2)*H'*Ys);

%3. Analysis mean
xma = mean(XA,2);

eb = norm(xmb-xt);
ea = norm(xma-xt);



















