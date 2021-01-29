f1 = [4.6857, 4.9469, 4.7033];
f2 = [3.4440, 3.7307, 3.8798];
f3 = [4.2909, 5.0493, 5.3035];
f4 = [4.2922, 4.2922, 4.2922];



fig = figure ;
hold all
plot([1 5 10],f1,'--bo','markersize',10,'markerfacecolor','b');
plot([1 5 10],f2,'--ko','markersize',10,'markerfacecolor','k');
plot([1 5 10],f3,'--ro','markersize',10,'markerfacecolor','r');
plot([1 5 10],f4,'--c','markersize',10,'markerfacecolor','r');
grid on
l =legend('r=1','r=2','r=3','Best LETKF');
xl = xlabel('Number of nodes (processors = 16*nodes)');
yl = ylabel('Root Mean Square Error (RMSE)');
set(xl,'fontsize',18);
set(yl,'fontsize',18);
set(l,'fontsize',18,'location','best');
print(fig,'-depsc','rmse.eps');
