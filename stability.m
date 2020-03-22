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
    
    
    
    
    %yaw stability
    
    plane.data.stability.yaw_is_stable = true;
    
    for i = 1:2
        b = plane.geo.wing.b;
        S_w = plane.geo.wing.S;
        S_v = plane.geo.v_tail.S;
        v_tail_c = plane.geo.v_tail.c;
        v_tail_h_cg = plane.geo.v_tail.h_cg(i);
        l_v = v_tail_h_cg*b - 0.25*v_tail_c;
        L_body = plane.geo.body.L;
        W_body = plane.geo.body.W;
        a_v = plane.geo.v_tail.cl_a;

        V_v = l_v*S_v /(S_w*b);
        V_fuselage = L_body*W_body;

        N_v = 0.8; %vertical tail effectiveness, Q_v/Q
        d_sigma_d_beta = 0.33; %sidewash
        C_y_b_tail = -N_v*V_v*a_v*(1+d_sigma_d_beta);

        C_nb = -C_y_b_tail - 2*V_fuselage/(S_w*b);
        C_nr = 2*C_y_b_tail*(l_v/b)^2;
        C_yr = -2*C_y_b_tail*l_v/b;

        if (C_nb < 0) && (C_nr > 0) && (C_yr < 0)
            plane.data.stability.yaw_is_stable = false;
        end
        
        plane.data.aero.C_yb = C_y_b_tail;
        
    end

    
    
end

