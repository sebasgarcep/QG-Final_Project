%Non-zeros elements for the SPEEDY model

clc 
clear all

d1 = 9; %One dimensional space x
d2 = 10; %Two dimensional space y
d3 = 8; %Three dimensional space z
r1 = 1; %Radius for space (points in the same plane)
r2 = 2; %Radius between layers

%See the grid

conteo = 0;

for r1 = 1:3
    
    for r2 = 1:2

%

n = d1*d2*d3; %Dimension of the vector state

M = zeros(n,n);

sp = 0;

p = 0;
for q = 1:d3
   for i = 1:d2
       for j = 1:d1
           p = p+1;
           sp = sp+1;
           M(p,p) = 1;
           I(sp) = p;
           J(sp) = p;
           V(sp) = 1;
           for k1 = q-r2:q+r2
              for k2= i-r1:i+r1
                  for k3 = j-r1:j+r1
                      k = (k1-1)*(d1*d2)+(k2-1)*d1+k3;
                      if k >= 1 && k<=n
                         M(p,k) = 1; 
                         sp = sp+1;
                         I(sp) = p;
                         J(sp) = k;
                         V(sp) = 1;
                      end
                  end
              end
           end
       end
   end
end

Msparse = sparse(I,J,V);

conteo = conteo+1;
subplot(2,3,conteo);
title(['r_{space} = ',num2str(r1), ' and r_{layers} = ',num2str(r2)],'fontsize',18);
spy(Msparse)

    end 
    
end