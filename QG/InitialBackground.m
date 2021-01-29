clc
clear all
close all

S = load('QG.mat','XB');

XB = S.XB;

[U,S,V] = svd(XB,'econ');

fig = figure;
plot(U(1,:),U(2,:),'*');
grid on

fig = figure;
plot3(U(1,:),U(2,:),U(3,:),'*');
grid on


fig = figure;
histogram2(U(1,:),U(2,:));