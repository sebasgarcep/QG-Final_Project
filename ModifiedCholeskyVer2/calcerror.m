function y = calcerror(a, b)
    % y = sqrt(norm(a - b) .^ 2 / 12);
    y = norm(a - b);
end

