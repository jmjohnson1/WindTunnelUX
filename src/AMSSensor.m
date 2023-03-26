classdef AMSSensor
    properties
        p_min
        p_max
        p_values
        t_values
        time
    end
    methods
        function obj = AMSSensor(min, max)
            if nargin == 2
                obj.p_min = min;
                obj.p_max = max;
            end
        end
    end
end