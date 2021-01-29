classdef (Abstract) Model < handle
    
    properties
    end
    
    methods (Abstract)
        dx = derivative(self, t, x)
    end
    
    methods
        function y = propagate(self, x, T)
            % x - initial condition
            % T - time window
            [~, Y] = ode45(@self.derivative, T, x);
            y = Y(end, :)';
        end
        
        function Y = propagate_ensemble(self, X, T)
            [n, N] = size(X);
            Y = zeros(n, N);
            for j = 1:N
                Y(:, j) = self.propagate(X(:, j), T);
            end 
        end
    end
    
end

