classdef (Abstract) Smoother < Filter
    
    properties
        L
        
        X
        C
        Y
        R
        H
        M
        T
        
        size
    end
    
    methods (Abstract)
        P = update_smoother(self, X, C, Y, R, H, M, T)
    end
    
    methods
        function self = Smoother(L)
            self.L = L;
            
            self.X = cell(1, L + 1);
            self.C = cell(1, L + 1);
            self.Y = cell(1, L + 1);
            self.R = cell(1, L + 1);
            self.H = cell(1, L + 1);
            self.M = cell(1, L + 1);
            self.T = cell(1, L + 1);
            
            self.size = 0;
        end
        
        function is_ready = absorb(self, X, C, Y, R, H, M, T)
            if self.size < (self.L + 1)
                self.size = self.size + 1;
                
                self.X{self.size} = X;
                self.C{self.size} = C;
                self.Y{self.size} = Y;
                self.R{self.size} = R;
                self.H{self.size} = H;
                self.M{self.size} = M;
                self.T{self.size} = T;
                
                is_ready = false;
            else
                for i = 1:(self.size - 1)
                    self.X{i} = self.X{i + 1};
                    self.C{i} = self.C{i + 1};
                    self.Y{i} = self.Y{i + 1};
                    self.R{i} = self.R{i + 1};
                    self.H{i} = self.H{i + 1};
                    self.M{i} = self.M{i + 1};
                    self.T{i} = self.T{i + 1};
                end
                
                self.X{self.size} = X;
                self.C{self.size} = C;
                self.Y{self.size} = Y;
                self.R{self.size} = R;
                self.H{self.size} = H;
                self.M{self.size} = M;
                self.T{self.size} = T;
                
                is_ready = true;
            end
        end
        
        function P = update(self, X, C, Y, R, H, M, T)
            % Absorb observation into smoother memory
            is_ready = self.absorb(X, C, Y, R, H, M, T);
            
            if is_ready
                P = update_smoother(self, X, C, Y, R, H, M, T);
            else
                P = M.propagate_ensemble(X, T);
            end
        end
    end
end

