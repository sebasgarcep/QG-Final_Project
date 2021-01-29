classdef IterativeEnsembleKalmanFilter < Filter
    
    properties
        max_iter
        epsilon
        tol
        lambda
        U
    end
    
    methods
        function self = IterativeEnsembleKalmanFilter(max_iter, epsilon, tol, lambda, U)
            self.max_iter = max_iter;
            self.epsilon = epsilon;
            self.tol = tol;
            self.lambda = lambda;
            self.U = U;
        end
        
        function [XP, CP] = update(self, X, C, Y, R, H, M, T)
            % Get ensemble size
            [~, N] = size(X);
            
            % Pick ensemble at t = 0
            E0 = X;
            
            % Obtain the observation covariance
            R1 = R;
            
            % Obtain the observation mean
            y1 = Y;
            
            % Initialize iterative minimizer
            w = zeros(N, 1);
            
            % Initialize iteration counter
            j = 0;
            
            % Initialize ensemble
            xi = E0 * ones(N, 1) / N;
            
            % Calculate ensemble abberation (difference with the mean)
            A0 = E0 - xi * ones(1, N);
            
            while true
                x0 = xi + A0 * w;
                E0 = x0 * ones(1, N) + self.epsilon * A0;
                E1 = M.propagate_ensemble(E0, T);
                y1_bar = H * E1 * ones(N, 1) / N;
                Y1 = (H * E1 - y1_bar * ones(1, N)) / self.epsilon; % FIX: multiply y1_bar with (1, 1, ... , 1)
                nabla_J = (N - 1) * w - Y1' / R1 * (y1 - y1_bar);
                H_tilde = (N - 1) * eye(N) + Y1' / R1 * Y1;

                % solve for delta_w in H_tilde * delta_w = na bla_J
                delta_w = linsolve(H_tilde, nabla_J);

                w = w - delta_w;
                j = j + 1;

                if (norm(delta_w) <= self.tol | j >= self.max_iter)
                    break
                end
            end
            
            E0 = x0 * ones(1, N) + sqrt(N - 1) * A0 * sqrtm(H_tilde) * self.U;
            E1 = M.propagate_ensemble(E0, T);
            x1_bar = E1 * ones(N, 1) / N;
            E1 = x1_bar * ones(1, N) + self.lambda * (E1 - x1_bar * ones(1, N));
            
            XP = E1;
            
            % Obtain the posterior error covariance
            CP = C;
        end
    end
    
end

