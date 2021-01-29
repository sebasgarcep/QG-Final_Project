%Radius of influence

fig = figure;

hold all

d = 0;

x = 6;
y = 6;

for i = 1:11
   for j = 1:11
        plot(i,j,'ko','MarkerSize',10,'MarkerFaceColor','k');
   end
end



for i = y-d:y+d
   for j = x-d:x+d
       plot(i,j,'bo','MarkerSize',10,'MarkerFaceColor','b');
   end
end

plot(x,y,'ro','MarkerSize',10,'MarkerFaceColor','r');

set(gca,'position',[0 0 1 1],'units','normalized')
axis off

print(fig,'-depsc',['Points',num2str(d),'.eps']);