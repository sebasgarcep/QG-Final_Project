clc
clear all
close all

n = 127;
dn = 5;

r = 1;
s = 1;

for i = 1:dn:n
   for j = 1:dn:n
       si = i-r:i+r;
       sj = j-r:j+r;
   end
end