classdef QGManager
    properties
    end
    
    methods
        function propagate(~, X, n, fileout)
            ncwrite('QG.nc', 'VOR', X);
            [~,~] = system(['./QGmodel prm.txt ', num2str(n)]);
            [~,~] = system(['mv QG_out.nc ', fileout]);
        end
        
        function Y = read(~, filename)
            Y = ncread(filename, 'VOR');
        end
        
        function write(~, X, filename)
            [~,~] = system(['touch ', filename]);
            ncwrite(filename, 'VOR', X);
        end
    end
end

