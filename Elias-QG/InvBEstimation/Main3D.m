%Non-zeros elements for the SPEEDY model

clc 
clear all

d1 = 9; %One dimensional space x
d2 = 10; %Two dimensional space y
d3 = 1; %Three dimensional space z
r1 = 3; %Radius for space (points in the same plane)
r2 = 3; %Radius between layers

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

set(gca,'fontsize',20);

print(fig,'-painters','-depsc',['grid_',num2str(r1),'_',num2str(r2),'.eps']);

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
                      if k<1
                          k = n+k;
                      else
                         if k>n
                             k = k-(n+1)+1;
                         end
                      end

		      if (k>=1 && k<n)
                      
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

fig = figure
title(['r_{space} = ',num2str(r1), ' and r_{layers} = ',num2str(r2)],'fontsize',18);
spy(M)

fig = figure
title(['r_{space} = ',num2str(r1), ' and r_{layers} = ',num2str(r2)],'fontsize',18);
spy(Msparse)
print(fig,'-painters','-depsc',['B_',num2str(r1),'_',num2str(r2),'.eps']);
