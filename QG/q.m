function xt = q(nc_file)
    Q=ncread(nc_file,'VOR');% surf(Q);figure;contour(Q);
    Qgorro=Q(2:end-1,2:end-1);
    xt=Qgorro(:);
end

