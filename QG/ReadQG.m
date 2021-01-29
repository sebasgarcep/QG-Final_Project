clc
clear all
close all

%Actual initial solution of the system
QGa =  ncread('QG0.nc','VOR');

%Creating an initial background state dynamically consistent with the
%dynamics of the model QG
QGb = QGa + 0.05*randn(129,129).*QGa;
ncwrite('QG.nc','VOR',QGb);
[status,cmdout] = system('./QGmodel prm.txt 100');

%Background inicial esta en QG_out.nc
[status,cmdout] = system('mv QG_out.nc QGb.nc');

%Generating the initial ensemble
for e = 1:40
   disp(['* Generating ',num2str(e)]);
   QGb =  ncread('QGb.nc','VOR');
   QGe = QGb + 0.05*randn(129,129).*QGb; 
   ncwrite('QG.nc','VOR',QGe);
   [status,cmdout] = system('./QGmodel prm.txt 100');
   [status,cmdout] = system(['mv QG_out.nc QG',num2str(e),'.nc']);
end

%Shift the actual state to current time
ncwrite('QG.nc','VOR',QGa);
[status,cmdout] = system('./QGmodel prm.txt 200');
[status,cmdout] = system('mv QG_out.nc QGa.nc');

%Assimilation window
for k = 1:12
   disp(['* Creating observation ',num2str(k)]);
   QGa =  ncread('QGa.nc','VOR');
   QGy = QGa + 0.01*randn(129,129).*QGa;
 %  nccreate(['QGy',num2str(k),'.nc'],'VOR','Dimensions',{'r',129,'c',129});%  'Format','classic')
   ncwrite(['QGy',num2str(k),'.nc'],'VOR',QGy);
   [status,cmdout] = system(['mv QGa.nc QGa',num2str(k),'.nc']);
   [status,cmdout] = system('mv QGa.nc QG.nc');
   [status,cmdout] = system('./QGmodel prm.txt 100');
   [status,cmdout] = system('mv QG_out.nc QGa.nc');
end

elias



QG_out = ncread('QG_out.nc','VOR');