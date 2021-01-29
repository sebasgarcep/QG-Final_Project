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

% Derived variables
gridsize = n * m * l;

% load ensembles
data = load('experiment.mat');
real = data.real';
ens = data.ens';
y = data.y';

Xrt1 = real(1:gridsize, :);

for i = 1:1
    for r = 1:1
        for s = 1:3
            for prop = 0.7:0.1:1
                filename = ['results/', 'i', num2str(i), 'r', num2str(r), 's', num2str(s), 'prop', num2str(prop), '.mat'];

                Xb = ens(:, randperm(1000, N));
                Xa = ModifiedCholesky(y, Xb, N, t, n, m, l, r, s, ts, dev, prop);

                Xbt1 = Xb(1:gridsize, :);
                Xat1 = Xa(1:gridsize, :);

                meanXbt1 = mean(Xbt1, 2);
                meanXat1 = mean(Xat1, 2);

                errb = error(meanXbt1, Xrt1);
                erra = error(meanXat1, Xrt1);

                save(filename, 'Xb', 'Xa', 'Ho', 'Q', 'Ac_inv', 'errb', 'erra');
            end
        end
    end
end
