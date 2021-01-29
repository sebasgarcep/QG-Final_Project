classdef QuasiGeostrophic < Model
    properties
        n
        m
        l
        r
        s
    end
    
    methods
        function self = QuasiGeostrophic(n, m, l, r, s)
            self.n = n;
            self.m = m;
            self.l = l;
            self.r = r;
            self.s = s;
        end
        
        function derivative(~, ~, ~)
            % not implemented
        end
        
        function p = influence(self, i)
            % location of current item in 3D space and time
            i0 = 1 + mod(i - 1, self.n * self.m * self.l);
            x0 = 1 + mod(i0 - 1, self.n);
            y0 = 1 + fix(mod(i0 - 1, self.n * self.m) / self.n);
            z0 = 1 + fix(mod(i0 - 1, self.n * self.m * self.l) / (self.n * self.m));

            % allocate memory to store basic predecessors
            b = zeros((2 * self.r + 1) .^ 2 - 1, 1);
            j = 0;

            % obtain the basic predeccesors surrounding our item i
            for dz = (-self.r):0
                z = z0 + dz;

                if z < 1 || z > self.l
                    continue
                end

                for dy = (-self.r):self.r
                    y = y0 + dy;

                    if y < 1 || y > self.m
                        continue
                    end

                    for dx = (-self.r):self.r
                        x = x0 + dx;

                        if x < 1 || x > self.n 
                            continue
                        end

                        j = j + 1;
                        ip = x + self.n * (y - 1) + self.n * self.m * (z - 1);
                        b(j) = ip;
                    end
                end
            end

            % reduce size of matrix fit
            b = b(1:j);
            
            % clone basic predecessors forward in time
            si = 1 + fix((i - 1) / (self.n * self.m  * self.l));
            lb = max([1 (si - self.s + 1)]); % make sure we don't go before t = 0
            frames = si - lb + 1;
            p = zeros(j * frames, 1);
            psize = 0;
            bsize = j;
            
            for t = lb:si
                bp = b + self.n * self.m * self.l * (t - 1);
                p((1 + psize):(bsize + psize)) = bp;
                psize = psize + bsize;
            end
            
            p = p(1:psize);
        end
    end
end