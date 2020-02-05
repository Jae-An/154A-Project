function stable = stability(plane)

    % static stability with neutral point
    h_acw = plane.geo.wing.h_ac;
    h_act = plane.geo.h_tail.h_ac;
    
    S_w = plane.geo.wing.S;
    S_t = plane.geo.h_tail.S;
    
    alpha_w = plane.geo.wing.alpha;
    alpha_t = plane.geo.h_tail.alpha;
    
    eps_alpha = .05; % random guess, need to refine
    
    h_n = (h_acw + h_act*(S_t/S_w)*(alpha_t/alpha_w) * (1-eps_alpha)) / (1 + ((St/Sw)*(alpha_t/alpha_w)*(1-eps_alpha)));
    plane.data.h_n = h_n;
    
    if (h_n > plane.geo.wing.h_cg)
        stable = true;
    else
        stable = false;
    end
    
    
end

