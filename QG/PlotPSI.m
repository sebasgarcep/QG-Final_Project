clear; 
clc;
fig = figure
Q = ncread('QG.nc','VOR');
imagesc(Q)
print(fig,'-dpng','Q1.png');

fig = figure
Q = ncread('QG_out.nc','VOR');
imagesc(Q)
print(fig,'-dpng','Q1_out.png');

%ncid = netcdf.open('QG_out.nc','NOWRITE')
%ncdisp('QG_out.nc')
contour(ncread('QG_out.nc','VOR'))
surf(ncread('QG_out.nc','VOR'))
%close all


