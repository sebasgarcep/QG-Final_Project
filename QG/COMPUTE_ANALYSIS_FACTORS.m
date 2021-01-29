function [L, D] = COMPUTE_ANALYSIS_FACTORS(L, D, X)
    %Set X=transpose(H)*R^.5
    global m
    disp('Estoy en COMPUTE_ANALYSIS_FACTORS(L, D, X)...');
    for i = 1:m
        % Set [L; D] =  UPD_CHOLESKY_FACTORS(L,D,xi)
        [L, D] =  UPD_CHOLESKY_FACTORS(L,D,X(:,i));
    end 
    % return [L D]
end   