function [Y] = propagateqg(X, n)
   ncwrite('QG.nc','VOR',QGe);
   [~,~] = system(['./QGmodel prm.txt ', num2str(n)]);
   Y = ncread('QG_out.nc', 'VOR');
end

