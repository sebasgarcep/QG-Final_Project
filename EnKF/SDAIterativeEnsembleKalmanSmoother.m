classdef SDAIterativeEnsembleKalmanSmoother < Smoother
    
    properties
        max_iter
        epsilon
        tol
        lambda
        U
    end
    
    methods
        function self = SDAIterativeEnsembleKalmanSmoother(max_iter, epsilon, tol, lambda, U, L)
            self@Smoother(L);
            self.max_iter = max_iter;
            self.epsilon = epsilon;
            self.tol = tol;
            self.lambda = lambda;
            self.U = U;
        end
        
        function [XP, CP] = update_smoother(self, X, C, Y, R, H, M, T)
            % Get ensemble size
            [~, N] = size(X);
            
            % Pick ensemble at t = 0
            E0 = self.X{1};
            
            % Obtain the observation covariance
            RL = R;
            
            % Obtain the observation mean
            yL = Y;
            
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
                
                EL = E0;
                for i = 1:self.L
                    EL = M.propagate_ensemble(EL, T);
                end

                yL_bar = H * EL * ones(N, 1) / N;
                YL = (H * EL - yL_bar * ones(1, N)) / self.epsilon; % FIX: multiply y1_bar with (1, 1, ... , 1)
                nabla_J = (N - 1) * w - YL' / RL * (yL - yL_bar);
                H_tilde = (N - 1) * eye(N) + YL' / RL * YL;

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

