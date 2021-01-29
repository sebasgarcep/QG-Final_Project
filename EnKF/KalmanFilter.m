classdef KalmanFilter < Filter
    
    properties
    end
    
    methods
        function [XP, CP] = update(~, X, C, Y, R, H, M, T)
            % Propagate the model in time
            X = M.propagate_ensemble(X, T);
            
            % Compute the Kalman gain
            K = C * H' / (H * C * H' + R);
            
            % Obtain the posterior estimate
            XP = X + K * (Y - H * X);
            
            % Recompute error covariance
            [n, ~] = size(C);
            CP = (eye(n) - K * H) * C;
        end
    end
    
end

