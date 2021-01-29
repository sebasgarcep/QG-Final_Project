%Non-zeros elements for the SPEEDY model

clc 
clear all

d1 = 11; %One dimensional space x
d2 = 11; %Two dimensional space y
d3 = 1; %Three dimensional space z
r1 = 3; %Radius for space (points in the same plane)

%See the grid



fig = figure
hold on

p1 = 6;
p2 = 6;

%Plot radius
vertices = [];

vertices = [ p1-r1 p2-r1; ...
             p1-r1 p2+r1; ...
             p1 p2+r1; ...
             p1 p2-r1; ...
             ];

squarePlot= fill(vertices(:,1),vertices(:,2),'b');

set(squarePlot,'FaceAlpha',0.2)
       
vertices = [ p1-1 p2-r1; ...
             p1-1 p2; ...
             p1 p2; ...
             p1 p2-r1; ...
             ];
         
squarePlot= fill(vertices(:,1),vertices(:,2),'w');

 set(squarePlot,'EdgeColor','None');


%Plot grid


   for i = 1:d2
      for j = 1:d1
         plot(j,i,'ko','Markerfacecolor','k','markeredgecolor','k'); 
      end
   end


%Plot the radius of influences (points)
i = p2;
j = p1;


    for k2= i-r1:i+r1
        for k3 = j-r1:j+r1
            plot(k3,k2,'o','markeredgecolor','b','Markerfacecolor','b','Markersize',10); 
        end
    end
    
   for k2= i:i
        for k3 = j:j+r1
            plot(k3,k2,'ko','Markerfacecolor','k','markeredgecolor','k'); 
        end
    end

     plot(p2,p1,'ro','markeredgecolor','r','Markerfacecolor','r','Markersize',10); 



%set(gca, 'Visible','off')
set(gca,'XTickLabel',[]);
set(gca,'YTickLabel',[]);

grid on




%title(['r_{space} = ',num2str(r1), ' and r_{layers} = ',num2str(r2)],'fontsize',18);

print(fig,'-depsc',['grid_pre_',num2str(r1),'.eps']);

%


