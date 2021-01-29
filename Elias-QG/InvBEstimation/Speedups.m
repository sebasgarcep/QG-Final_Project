f1 = [14.089966679, 13.7195519791, 13.7535837416];
f2 = [7.2747629293, 7.130049105, 7.1450436162];
f3 = [4.2532249646, 4.3209419431, 4.347275975];

fig = figure ;
hold all
plot([1 5 10],f1,'--bo','markersize',10,'markerfacecolor','b');
plot([1 5 10],f2,'--ko','markersize',10,'markerfacecolor','k');
plot([1 5 10],f3,'--ro','markersize',10,'markerfacecolor','r');
grid on
l =legend('r=1','r=2','r=3');
xl = xlabel('Number of nodes (processors = 16*nodes)');
yl = ylabel('Speedup (Time LETKF / Time EnKFBinvEst)');
set(xl,'fontsize',18);
set(yl,'fontsize',18);
set(l,'fontsize',18,'location','best');
print(fig,'-depsc','speedups.eps');
