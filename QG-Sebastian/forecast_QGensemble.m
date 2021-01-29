function XB = forecast_QGensemble(XB,N)
    for i = 1:N 
        XB(:,i) = propagate_QGmodel(XB(:,i));
    end
end