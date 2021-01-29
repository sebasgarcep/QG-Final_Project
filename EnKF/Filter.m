classdef (Abstract) Filter < handle
    
    properties
    end
    
    methods (Abstract)
        [XP, CP] = update(self, X, C, Y, R, H, M, T)
    end
    
end

