% Driver for QG Model 
    clc;
    clear variables; 
    close all;
    
    Variables
    %% Begin - experimental settings
    xt = q('QG0.nc');
    % xb0 = xt+errb*randn(n,1); 
    xtp = perturb('QG.nc',xt);
    
    %propagate_model
    !./QGmodel prm.txt 100;
    
    %%Background state
    xb0 = q('QG_out.nc');
    %% Initial ensemble
    XB=zeros(n,N);
    for i = 1:N
        XB(:,i) = perturb('QG.nc',xb0);
        !./QGmodel prm.txt 100;
        XB(:,i) = q('QG_out.nc');
    end
    %End - experimental settings
    XB
    L=eye(n);