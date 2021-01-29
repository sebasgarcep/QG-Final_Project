%x - initial condition
%T - time window

function y = propagate_model(x,T)
[~,Y] = ode45(@Lorenz96,T,x);
y = Y(end,:)';
end