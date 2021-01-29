%Non-zeros elements for the SPEEDY model

clc 
clear all

d1 = 9; %One dimensional space x
d2 = 10; %Two dimensional space y
d3 = 8; %Three dimensional space z
r1 = 5; %Radius for space (points in the same plane)
r2 = 2; %Radius between layers

%See the grid



fig = figure
hold on

p1 = 5;
p2 = 5;
p3 = 5;

%Plot grid
for q = 1:d3
   for i = 1:d2
      for j = 1:d1
         plot3(j,i,q,'ko'); 
      end
   end
end

%Plot the radius of influences (points)
q = p3;
i = p2;
j = p1;

vertices = [];

for k1 = q-r2:q+r2
    for k2= i-r1:i+r1
        for k3 = j-r1:j+r1
            plot3(k3,k2,k1,'o','Markerfacecolor','b','Markersize',8); 
        end
    end
end

vertices = [ p1-r1 p2-r1 p3-r2; ...
             p1-r1 p2+r1 p3-r2; ...
             p1+r1 p2+r1 p3-r2; ...
             p1+r1 p2-r1 p3-r2; ...
             p1-r1 p2-r1 p3+r2; ...
             p1-r1 p2+r1 p3+r2; ...
             p1+r1 p2+r1 p3+r2; ...
             p1+r1 p2-r1 p3+r2];

faces = [1 2 3 4; 2 6 7 3; 4 3 7 8; 1 5 8 4; 1 2 6 5; 5 6 7 8];
cubePlot = patch('Vertices', vertices, 'Faces', faces);

set(cubePlot,'FaceAlpha',0.2)

%Point to assimilate
plot3(p3,p2,p1,'o','Markerfacecolor','r','Markersize',8); 

az =37;
el = 4;

view(az,el)

title(['r_{space} = ',num2str(r1), ' and r_{layers} = ',num2str(r2)],'fontsize',18);

grid on

%

n = d1*d2*d3; %Dimension of the vector state

M = zeros(n,n);

sp = 0;

p = 0;

q = 1;
i = 1;
j = 1;

S = [];

for k1 = q-r2:q+r2
    for k2= i-r1:i+r1
        for k3 = j-r1:j+r1
            k = (k1-1)*(d1*d2)+(k2-1)*d1+k3;
            S = [S k];
        end
    end
end

nonZeros = length(S); %Number of non-zero elements per row

sp = 0;

for i = 1:n
    for j = 1:nonZeros
        p = checkBoundary(S(j),n);
        sp = sp+1;
        M(i,p) = 1;
        I(sp) = i;
        J(sp) = p;
        V(sp) = 1; %Value
    end
    S = S+ones(1,nonZeros);
end

Msparse = sparse(I,J,V);

fig = figure
title(['r_{space} = ',num2str(r1), ' and r_{layers} = ',num2str(r2)],'fontsize',18);
spy(M)

fig = figure
title(['r_{space} = ',num2str(r1), ' and r_{layers} = ',num2str(r2)],'fontsize',18);
spy(Msparse)