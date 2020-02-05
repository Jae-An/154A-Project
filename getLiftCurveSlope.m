function cl_alpha = getLiftCurveSlope(wing_type)

    %works for elliptical wings, not too far off other types

    % needs to be passed plane.geo.wing or plane.geo.h_tail, etc.
    ar = wing_type.AR;
    
    cl_alpha = 7; % 2pi is max
    tolerance = 0.001;
    error = 10;
    step = 0.001;
    
    while (error > tolerance)
        
        error = cl_alpha - (cl_alpha / (1 + (cl_alpha / (3.14*ar))));
        
        cl_alpha = cl_alpha - step;
    end
        
    return
end

