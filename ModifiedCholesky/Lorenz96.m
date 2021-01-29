classdef Lorenz96 < Model
    properties
        f
    end
    
    methods
        function self = Lorenz96(f)
            self.f = f;
        end
        
        function dx = derivative(self, ~, x)
            [n, ~] = size(x);

            dx = zeros(n, 1);

            dx(1) = - x(n) * (x(n - 1) - x(2)) - x(1) + self.f;
            dx(2) = - x(1) * (x(n) - x(3)) - x(2) + self.f;

            for i = 3:(n - 1)
                dx(i) = - x(i - 1) * (x(i - 2) - x(i + 1)) - x(i) + self.f;
            end

            dx(n) = - x(n - 1) * (x(n - 2) - x(1)) - x(n) + self.f;
        end
        
        function p = influence(self, i)
            p = sort([
                1 + mod(i - 1, self.f)
                1 + mod(i - 1 - 1, self.f)
                1 + mod(i - 1 - 2, self.f)
                1 + mod(i - 1 + 1, self.f)
            ]);
        end
    end
end