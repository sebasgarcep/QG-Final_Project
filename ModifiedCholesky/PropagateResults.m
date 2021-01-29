clc;
clear all;
close all;
warning('off', 'all');

% variables
manager = QGManager();
t = 12;
numexperiments = 3 * 3 * 3 * 20;
n = 127;
m = 127;
tmp = 'QGtemp';

Lr = zeros(numexperiments, 1);
Ls = zeros(numexperiments, 1);
Lprop = zeros(numexperiments, 1);
Liter = zeros(numexperiments, 1);
LXb = zeros(numexperiments, t, n, m);
LXa = zeros(numexperiments, t, n, m);

Qtmp = zeros(n + 2, m + 2);
idx = 0;

for r = 1:3
    for s = 1:3
        for prop = 0.5:0.2:0.9
            for iter = 1:20
                idx = idx + 1;
                
                display(['* Propagating results for # ', num2str(idx)]);
                tic
                
                filename = ['results/', 'r', num2str(r), 's', num2str(s), 'prop', num2str(prop), 'iter', num2str(iter), '.mat'];
                data = load(filename);
                
                Lr(idx) = r;
                Ls(idx) = s;
                Lprop(idx) = prop;
                Liter(idx) = iter;
                LXb(idx, 1, :, :) = data.MXb;
                LXa(idx, 1, :, :) = data.MXa;
                
                for k = 2:t
                    display(['* Propagating background and analysis at time t = ', num2str(k)]);
                    
                    Qtmp(2:(n + 1), 2:(m + 1)) = squeeze(LXb(idx, k - 1, :, :));
                    manager.propagate(Qtmp, 100, tmp);
                    Qtmp = manager.read(tmp);
                    LXb(idx, k, :, :) = Qtmp(2:(n + 1), 2:(m + 1));
                    
                    Qtmp(2:(n + 1), 2:(m + 1)) = squeeze(LXa(idx, k - 1, :, :));
                    manager.propagate(Qtmp, 100, tmp);
                    Qtmp = manager.read(tmp);
                    LXa(idx, k, :, :) = Qtmp(2:(n + 1), 2:(m + 1));
                end
                
                toc
            end
        end
    end
end

numitems = idx;
save Propagation Lr Ls Lprop Liter LXb LXa numitems;