function dx = Lorenz96(t,x)

global P n

F = P.F;

dx = zeros(n,1);

dx(1) = -x(n)*(x(n-1)-x(2))-x(1)+F;
dx(2) = -x(1)*(x(n)-x(3))-x(2)+F;

for i = 3:n-1
    dx(i) = -x(i-1)*(x(i-2)-x(i+1))-x(i)+F;
end

dx(n) = -x(n-1)*(x(n-2)-x(1))-x(n)+F;

end