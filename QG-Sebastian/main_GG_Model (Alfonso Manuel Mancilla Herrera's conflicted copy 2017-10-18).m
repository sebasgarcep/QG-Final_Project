% Driver for QG Model 
    clc;
    clear variables; 
    close all;
    
    Variables
    %% Begin - experimental settings
    %  Initial condition
    xt = q('QG0.nc');
    %  Background state
    xtp = xt+errb*randn(length(xt),1); 
    xt = propagate_QGmodel(xt);
    xb0 = propagate_QGmodel(xtp); 
    
    %% Initial ensemble
    XB=zeros(n*n,N);
    for i = 1:N
        XB(:,i) = xb0+errb*randn(length(xb0),1);
        XB(:,i) = propagate_QGmodel(XB(:,i));
    end
    xt = propagate_QGmodel(xt);
    
    %End - experimental settings
    for k = 1:M
        %Reference solution
        xt = propagate_QGmodel(xt);    

        %Forecast ensemble
        XB = forecast_QGensemble(XB,N);
        xmb = mean(XB,2);

        % Observation (from the actual value)
        % H = randperm(n,m);
        % y = xt(H)+erro*randn(m,1);

        %[XA, xma] = analysis_ensemble_mod_Cholesky_PEnKF_S(XB,xmb,N,m,H,y,r);

        EA(k+1) = norm(xma-xt);
        EB(k+1) = norm(xmb-xt);
        DXA = XA-xma*ones(1,N);
        XB = xma*ones(1,N)+infla*DXA;
    end
% xt(2000:2001)
% xb(2000:2001)
% figure;
% hold on
% plot (xb(2000),xb(2001),'*b');
% plot (xt(2000),xt(2001),'*r');
% norm(xb-xt)


    
    