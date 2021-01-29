function [L, D]=UPD_CHOLESKY_FACTORS(L,D,x)
        global n
        % Compute p from transpose(L)*p = x, donde p es una  matriz de n*m
        p=transpose(L)\x;
        %%
        %Lt(i,i)=sparse(n,n);
        %D = vector 
        % for i = n:1
        for i=n:-1:1
            % Compute d� via equation (10a)
            Dt(i,i)=p(i)^2+D(i,i);
            for k=i+1:n
                Dt(i,i)=Dt(i,i)-Dt(k,k)*(Lt(k,i))^2;
            end
            % Set l(i,i)=1
            Lt(i,i)=1;
            % for j = 1:i- 1
            %% Vecinos - de i
            for j=1:i-1 
                % Compute �l(i,j) according to (10b)
                Lt(i,j)=(p(i)*p(j));
                for k=i+1:n
                    Lt(i,j)=Lt(i,j)-Dt(k,k)*Lt(k,i)*Lt(k,j); %Acumula en s = s+Dt(k,k)*Lt(k,i)*Lt(k,j)
                end
                %Actualiza Lt(i,j)
                Lt(i,j)=Lt(i,j)/Dt(i,i);
            % end 
            end
        % end 
        end
        % Set L = L � L�; D = D�;
         L = Lt*L;D=Dt;
%     return L, D
end