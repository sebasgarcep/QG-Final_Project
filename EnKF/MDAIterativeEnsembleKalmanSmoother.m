classdef MDAIterativeEnsembleKalmanSmoother < Smoother
    
    properties
        max_iter
        epsilon
        tol
        lambda
        U
        beta
    end
    
    methods
        function self = MDAIterativeEnsembleKalmanSmoother(max_iter, epsilon, tol, lambda, U, L, beta)
            self@Smoother(L);
            self.max_iter = max_iter;
            self.epsilon = epsilon;
            self.tol = tol;
            self.lambda = lambda;
            self.U = U;
            self.beta = beta;
        end
        
        function [XP, CP] = update_smoother(self, X, C, Y, R, H, M, T)
            % Get ensemble size
            [~, N] = size(X);
            
            % Pick ensemble at t = 0
            E0 = self.X{1};
            
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
                
                E = cell(1, self.L);
                y_bar = cell(1, self.L);
                Yi = cell(1, self.L);

                for k = 1:self.L
                    if k == 1
                        E_prev = E0;
                    else
                        E_prev = self.X{k};
                    end
                    E{k} = M.propagate_ensemble(E_prev, T);
                    Hk = self.H{k + 1};
                    y_bar{k} = Hk * E{k} * ones(N, 1) / N;
                    Yi{k} = (Hk * E{k} - y_bar{k} * ones(1, N)) / self.epsilon; % FIX: multiply y1_bar with (1, 1, ... , 1)
                end

                nabla_J_sum = 0;
                for k = 1:self.L
                    nabla_J_sum = nabla_J_sum + Yi{k}' / self.R{k + 1} * (self.Y{k + 1} - y_bar{k});
                end

                H_tilde_sum = 0;
                for k = 1:self.L
                    H_tilde_sum = H_tilde_sum + Yi{k}' / self.R{k + 1} * Yi{k};
                end

                nabla_J = (N - 1) * w - nabla_J_sum;
                H_tilde = (N - 1) * eye(N) + H_tilde_sum;

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

