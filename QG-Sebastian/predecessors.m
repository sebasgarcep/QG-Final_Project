function p = predecessors(n, m, l, r, s, i)
    % location of current item in 3D space and time
    x0 = 1 + mod(i - 1, n);
    y0 = 1 + fix(mod(i - 1, n * m) / n);
    z0 = 1 + fix(mod(i - 1, n * m * l) / (n * m));
    s0 = 1 + fix((i - 1) / (n * m  * l));
    
    % allocate memory to store basic predecessors
    b = zeros(2 * r .^ 2 + 2 * r, 1);
    j = 0;
    
    % obtain the basic predeccesors surrounding our item i
    for dz = (-r):0
        z = z0 + dz;
        
        if z < 1 || z > l
            continue
        end
        
        for dy = (-r):r
            y = y0 + dy;
            
            if y < 1 || y > m
                continue
            end
            
            for dx = (-r):r
                x = x0 + dx;
                
                if x < 1 || x > n 
                    continue
                end
                
                if dx == 0 && dy == 0 && dz == 0
                    % reduce size of matrix fit
                    b = b(1:j);
                    
                    % clone basic predecessors backwards in time
                    p = zeros(j * s, 1);
                    for ds = (-s + 1):0
                        t = s0 + ds;
                        k = s - 1 + ds;
                        low = 1 + j * k;
                        upp = j * (k + 1);
                        p(low:upp) = b + n * m * l * (t - 1);
                    end
                    
                    return
                end

                j = j + 1;
                b(j) = x + n * (y - 1) + n * m * (z - 1);
            end
        end
    end
end