%

warning off

n = 40;
N = 20;

r = 2;



B = 0.05*eye(n,n);

X = mvnrnd(zeros(n,1),B,N)';

X = (X-mean(X,2)*ones(1,N))';

figure
imagesc(B)
colorbar

L = zeros(n,n);

d = 4;

for k = 2:n
    Z = [];
    for j = k-d:k-1
        if j>=1
        Z = [Z X(:,j)]; 
        end
    end
   
    disp(['[',num2str(k),'] Condition number is ',num2str(cond(Z'*Z))])
    betas = ((Z'*Z)\(Z'*X(:,k)))';
    i =0;
    for j = k-d:(k-1)    
        if j>=1
            i = i+1;
            L(k,j) = betas(i);
        end
    end
end

T = eye(n,n)-L;

fig = figure
mesh(T)

D = 0.05^2*eye(n,n);

Best = T*D*T';

%Best = T*inv(D)*T';
fig = figure
spy(Best)


