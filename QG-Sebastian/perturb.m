function [xp, nc_file_out] = perturb(nc_file,x)
    global n errb
    Q=ncread(nc_file,'VOR');
    xp = x+errb*randn(n,1);
    nf=sqrt(n);
    Q(2:end-1,2:end-1)=reshape(xp,nf,nf);
    ncwrite(nc_file,'VOR',Q);
end

