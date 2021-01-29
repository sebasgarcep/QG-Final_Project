classdef EnsembleKalmanFilter < Filter
    
    properties
    end
    
    methods
        function [XP, CP] = update(~, X, ~, Y, R, H, M, T)
            % Propagate the model in time
            X = M.propagate_ensemble(X, T);
            
            % Obtain the ensemble covariance
            C = cov(X');
            
            % Obtain the perturbed data matrix
            [~, N] = size(X);
            [m, ~] = size(Y);
            D = Y * ones(1, N) + mvnrnd(zeros(N, m), R)';
            
            % Compute the Kalman gain
            K = C * H' / (H * C * H' + R);
            
            % Obtain the posterior estimate
            XP = X + K * (D - H * X);
            
            % Obtain the posterior error covariance
            CP = C;
        end
    end
    
end

