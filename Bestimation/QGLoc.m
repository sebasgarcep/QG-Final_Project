%For the quasi-geostrophic model

clc
clear all

n = 10;

m = 10;

Nstate = n*m;

d = 1;

B = zeros(Nstate,Nstate);

f = 0;
for i = 1:n
    for j = 1:m
        f = f+1;
        for l = i-d:i+d
            for q = j-d:j+d
                k = (l-1)*m+q;
                if k>=1 && k<=Nstate
                   B(f,k) = 1; 
                end
            end
        end
    end
end

fig = figure
spy(B,7);
print(fig,'-depsc',['Sparse',num2str(d),'.eps']);
