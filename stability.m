function plane = stability(plane)

    % static stability with neutral point
    h_acw = plane.geo.wing.h_ac;
    h_act = plane.geo.h_tail.h_ac;
    
    S_w = plane.geo.wing.S;
    S_t = plane.geo.h_tail.S;
    
    alpha_w = plane.geo.wing.cl_a;
    alpha_t = plane.geo.h_tail.cl_a;
    
    eps_alpha = 0.3; % random guess, need to refine
    
    h_n = (h_acw + h_act*(S_t/S_w)*(alpha_t/alpha_w) * (1-eps_alpha)) / (1 + ((S_t/S_w)*(alpha_t/alpha_w)*(1-eps_alpha)));
    
    plane.data.stability.h_n = h_n;
    
    if (h_n > plane.geo.wing.h_cg)
        plane.data.stability.is_stable = true;
    else
        plane.data.stability.is_stable = false;
    end
    
end

