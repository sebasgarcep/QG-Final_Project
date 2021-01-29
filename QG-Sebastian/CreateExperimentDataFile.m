clc;
clear all;
close all;
warning('off', 'all');

manager = QGManager();

% Initialize variables
N = 40;
t = 12;
n = 127;
m = 127;
l = 1;
r = 1;
s = 1;
ts = 0.1;

% Derived variables
gridsize = n * m * l;

% load ensembles
ens = zeros(N, t * gridsize);
for h = 1:t
    for k = 1:N
        mat = manager.read(['QGe_t', num2str(h), '_n', num2str(k), '.nc']);
        mat = mat(2:(n + 1), 2:(n + 1))';
        vec = mat(:);
        ens(k, (1 + (h - 1) * gridsize):(h * gridsize)) = vec';
    end
end

y = zeros(1, t * gridsize);
for h = 1:t
    mat = manager.read(['QGy_t', num2str(h), '.nc']);
    mat = mat(2:(n + 1), 2:(n + 1))';
    vec = mat(:);
    y(1, (1 + (h - 1) * gridsize):(h * gridsize)) = vec';
end

save experiment ens y;