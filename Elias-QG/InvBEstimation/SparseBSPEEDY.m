d3 = 8;
d2 = 


sp = 0;

p = 0;

q = 1;
i = 1;
j = 1;

S = [];

for k1 = q-r2:q+r2
    for k2= i-r1:i+r1
        for k3 = j-r1:j+r1
            k = (k1-1)*(d1*d2)+(k2-1)*d1+k3;
            S = [S k];
        end
    end
end

nonZeros = length(S); %Number of non-zero elements per row

sp = 0;

for i = 1:n
    for j = 1:nonZeros
        p = checkBoundary(S(j),n);
        sp = sp+1;
        M(i,p) = 1;
        I(sp) = i;
        J(sp) = p;
        V(sp) = 1; %Value
    end
    S = S+ones(1,nonZeros);
end

Msparse = sparse(I,J,V);

fig = figure
title(['r_{space} = ',num2str(r1), ' and r_{layers} = ',num2str(r2)],'fontsize',18);
spy(M)

fig = figure
title(['r_{space} = ',num2str(r1), ' and r_{layers} = ',num2str(r2)],'fontsize',18);
spy(Msparse)
