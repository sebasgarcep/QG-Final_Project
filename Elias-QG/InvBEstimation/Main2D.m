%Non-zero elements for the QG-modelzer

d1 = 35;
d2 = 35;
r = 1;

n = d1*d2;

M = zeros(n,n);

p = 0;
for i = 1:d2
   for j = 1:d1
       p = p+1;
       M(p,p) = 1;
       for k1 = i-r:i+r
          for k2= j-r:j+r
              k = (k1-1)*d1+k2;
              if k >= 1 && k<=n
                 M(p,k) = 1; 
              end
          end
       end
   end
end

spy(M)


