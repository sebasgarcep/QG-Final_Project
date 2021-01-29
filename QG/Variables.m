%Variables
global m n erro errb N 

r = 3;randi(3,n,1);

%% n - number of model components
n=16129;

%% N - number of model realizations
N = 1000;

%% M - Assimilation steps
M = 1;

%% m - number of observed components from model state
dm=2;
H=1:dm:n;
m=length(H);

%% nruns - number of samples
nruns=50;

%% Errors
errb = 0.05; 
erro = 0.01;
R = erro^2*eye(m,m);

%% Radio de influencia
ratio = [1 2 3];
inflation = [1.00 1.02 1.04];

%% n_iter - number of model iterations
n_iter=[length(ratio) length(inflation)];
ns=prod(n_iter);

%% T - forecast step
T0 = [0 10]; %Ensemble initialization
T = [0 0.5]; %Forecast step
TJ = 0:0.01:1; %Plot ensemble trajectories










