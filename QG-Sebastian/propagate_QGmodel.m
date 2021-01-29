function xt = propagate_QGmodel(x)
    global n
    Q=ncread('QG.nc','VOR');
    nf=sqrt(n);
    Q(2:end-1,2:end-1)=reshape(x,nf,nf);
    ncwrite('QG.nc','VOR',Q);
    system('./QGmodel prm.txt 100');
    %!./QGmodel prm.txt 100;
    xt= q('QG_out.nc');   
end
