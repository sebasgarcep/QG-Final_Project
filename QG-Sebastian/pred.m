function p = pred(k,r)
    global n
    i=rem(k-1,n)+1;
    j=(k-i+n)/n;
    m=reshape(1:n*n,n,n);
    neighbors=m(max(i-r,1):min(i+r,n),max(j-r,1):min(j+r,n));
    p=neighbors(neighbors<k);
end

