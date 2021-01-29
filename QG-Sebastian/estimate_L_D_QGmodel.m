function [L, D] = estimate_L_D_QGmodel(XB,r)
    global n
    L = eye(n,n); %Sparse Matrices L = speye(n,n);
    D(1,1) = 1/var(XB(1,:)); %Sparse Matrices D = vector
    disp('Estoy en estimate_L_D_QGmodel(XB,r)...');
    for i = 2:n
        pi=pred(i,r);
        Y = XB(i,:);
        X = XB(pi,:);
        beta = pinv(X*transpose(X),0.05)*(X*transpose(Y));
        %Beta - no - svd Tikhonov regularization. [U,S,V] = svd(X,0);
        L(i,pi) = -beta;
        D(i,i) = 1/var(transpose(Y)-transpose(X)*beta); %D(i)
    end
end