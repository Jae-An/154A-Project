function cl_alpha = getLiftCurveSlope(wing_type)

    %works for elliptical wings, not too far off other types
    wing_type = 'NACA2412';
    load NACA2412 x2412 y2412
    cl_alpha = (airfoil(x2412, y2412,4)-airfoil(x2412, y2412,2))/(2*pi/180);
    
%     % needs to be passed plane.geo.wing or plane.geo.h_tail, etc.
%     ar = wing_type.AR;
%     
%     cl_alpha = 7; % 2pi is max
%     tolerance = 0.001;
%     error = 10;
%     step = 0.001;
%     
%     while (error > tolerance)
%         
%         error = cl_alpha - (cl_alpha / (1 + (cl_alpha / (3.14*ar))));
%         
%         cl_alpha = cl_alpha - step;
%     end
        
    return
end

