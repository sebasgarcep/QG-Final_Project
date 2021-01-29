clc
clear all
close all

% Samples N
% Levels l
% Variables v
% d1 - Dimension 1
% d2 - Dimension 2

data = load('Samples.mat');

r = 1;
t = 1;
n = 8; %n
m = 8; %n
l = 3; %l
v = 6; %1


p = 0;

for d = 1:2
for k = 1:l
    for c = 1:v
        for i = 1:n
            for j = 1:m
                p = p+1;
                M(j,i,c,k,d) = p;
            end
        end
    end
end
end

VM = M(:);

p = 0;

z = 2*n*m*l*v;

ts = 0.1;


X = [data.H3(:,1:end-1);data.H0(:,2:end)];
[N1,N2] = size(X);
xm = mean(X,2);
DX = X-xm*ones(1,N2);


Binv = sparse(z,z);
L = sparse(z,z);
D = speye(z,z);
for d = 1:2
for k = 1:l
    for c = 1:v
        for i = 1:n
            for j = 1:m
                p = p+1;
                L(p,p) = 1;
                nv=[];
                for di = 1:2
                for ki = k-t:k+t
                    if ki>=1 && ki <=l
                        for ci = 1:v
                            for ni = i-r:i+r
                                for nj = j-r:j+r
                                    if ni>=1 && nj>=1 && ni<=n && nj<=m
                                        ind = M(nj,ni,ci,ki,di);
                                        if (ind~=p)
                                            nv=[nv,ind];
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                end
                inp = find(nv<p);
                if ~isempty(inp)
                    
                    xi = DX(p,:)';
                    pi = DX(inp,:)';
                    
                    nB = size(pi,1);
                    [U,S,V] = svd(pi,'econ');
                    dS = diag(S);
                    mS = length(S);
                    maxS = max(dS);
                    bet = zeros(nB,1);
                    for g = 1:mS
                        if dS(g)/maxS < ts
                           break;
                        end
                    end
                    g = g-1;
                    bet = V(:,1:g)*(S(1:g,1:g)\(U(:,1:g)'*xi));
                    
                    L(p,nv(inp))= -bet;
                end
                %elias
            end
        end
    end
end
end

Dinv = inv(spdiags(var((L*DX)')',0,D));
Binv = L'*Dinv*L;
B = inv(Binv);
save('B30')


