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
data = load('experiment.mat', 'real');
real = data.real';

Xrt1 = real(1:gridsize, :);

rowidx = 0;
data = [];

for i = 1:1
    for r = 1:1
        for s = 1:3
            for prop = 0.7:0.1:1
                filename = ['results/', 'i', num2str(i), 'r', num2str(r), 's', num2str(s), 'prop', num2str(prop), '.mat'];

                if ~exist(filename)
                    table = array2table(data);

                    table.Properties.VariableNames = {
                        'Iteration',
                        'Spatial_Radius',
                        'Temporal_Radius',
                        'Proportion_of_Observed_Components',
                        'RMSE_Background_Full',
                        'RMSE_Analysis_Full',
                        'RMSE_Background_Only_observed_components',
                        'RMSE_Analysis_Only_observed_components'
                    };

                    outname = 'experiment_results.csv';
                    writetable(table, outname);

                    return
                end

                load(filename);

                Xbt1 = Xb(1:gridsize, :);
                Xat1 = Xa(1:gridsize, :);
                meanXbt1 = mean(Xbt1, 2);
                meanXat1 = mean(Xat1, 2);
                Hp = Ho(1:gridsize, 1);
                errbprop = rmse(meanXbt1(Hp == 1), Xrt1(Hp == 1));
                erraprop = rmse(meanXat1(Hp == 1), Xrt1(Hp == 1));

                rowidx = rowidx + 1;
                data(rowidx, :) = [i r s prop errb erra errbprop erraprop];
            end
        end
    end
end