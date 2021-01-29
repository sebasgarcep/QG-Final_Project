function err = materr(M)
    err = 0;
    [~, N] = size(M);
    for i = 1:N
        err = err + norm(M(:, i));
    end
    err = sqrt(err);
end

