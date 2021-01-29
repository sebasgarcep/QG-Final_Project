function kout = checkBoundary(k,n)
kb = k;
if k<1
    kb = n+k;
else
    if k>n
        kb = k-(n+1)+1;
    end
end
kout = kb;
end