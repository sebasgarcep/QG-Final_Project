%XA = (inv(PB)+H'*inv(R)*H)\(inv(PB)*XB+H'*inv(R)*Ys) An�lisis Cholesky modificado 

%xma = xmb + z; A^(-1)*z = q; q = H'*R^(-1)*(y-H*mxb); An�lisis Paper
%%
function [XA,xma] = analysis_QGensemble_mod_Cholesky(XB,xmb,N,m,H,y,r)
global erro n

%Estimating B inverse via modified Cholesky decom.
DX=XB-xmb*ones(1,N);
[L, D] = estimate_L_D_QGmodel(DX,r);
%Binv=L'*D*L;
i=1:m;
j=H;

k=(i-1)*n+j;
%[i' j' k']
Ht=zeros(n,m);
Ht(k)=1;
X = Ht/erro;
r
[Lt, Dt] = COMPUTE_ANALYSIS_FACTORS(L, D, X);
%%
% disp('Ltt*Dt*Lt');
% disp(Lt'*Dt*Lt);
% disp('Lt*D*L+X*Xt');
% disp(Binv+X*X');
%%
%Synthetic observations
disp('ASSIMILATION');
Ys = y*ones(1,N)+erro*randn(m,N);
%%
DY  = Ys-Ht'*XB;
xmb = mean(XB,2);
q   = (Ht/erro^2)*(y-Ht'*xmb);
%z   = Lt\(Dt\(Lt'\q));
z   = (Lt'*Dt*Lt)\q;
xma = xmb+z;
%%
W   = randn(n,N);
DXa = (Lt*sqrt(Dt))\W;
XA  = xma * ones(1,N) + DXa;

% Sb = XB-xmb*ones(1,N);
% W = Binv;
% Z = Binv*XB;
% for i = 1:m
%    j = H(i);
%    W(j,j) = W(j,j) + 1/erro^2; 
%    Z(j,:) = Z(j,:) + (1/erro^2)*Ys(i,:);
% end
% XA = W\Z;
end