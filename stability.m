function plane = stability(plane)

    %% static stability with neutral point
    h_acw = plane.geo.wing.h_ac;
    h_act = plane.geo.h_tail.h_ac;
    
    S_w = plane.geo.wing.S;
    S_t = plane.geo.h_tail.S;
    
    alpha_w = plane.geo.wing.cl_a;
    alpha_t = plane.geo.h_tail.cl_a;
    
    epsilon_alpha = 0.3; % random guess, need to refine
    
    h_n = (h_acw + h_act*(S_t/S_w)*(alpha_t/alpha_w) * (1-epsilon_alpha)) / (1 + ((S_t/S_w)*(alpha_t/alpha_w)*(1-epsilon_alpha)));
    
    plane.data.stability.h_n = h_n;
    h_cg = plane.geo.wing.h_cg; %h_cg(1) = fueled cg, h_cg(2) = un fueled cg
    
    if (h_n > h_cg(1,1)) && (h_n > h_cg(2,1))
        plane.data.stability.is_stable = true;
    else
        plane.data.stability.is_stable = false;
    end
   
     %% tail incidence and alpha to trim check
    wing_c = plane.geo.wing.c;
    i_t = zeros(2,2);
    for i = 1:2 %loops for fueled and unfueled CG's(1st loop is fueled, 2nd loop is unfueled)
        for j = 1:2 % loops for with and without retardent,1 = wet (with retardent), 2 = dry (without retardent)
            l_t = wing_c*(plane.geo.wing.c*plane.geo.h_tail.h_ac  - h_cg(i,1));

            CM_AC = 0;
            CL_alpha = (alpha_w + alpha_t*(S_t/S_w)*(1 - epsilon_alpha));
            CM_alpha = -CL_alpha*(h_n - h_cg(i,1));
            CL = plane.data.aero.CL_cruise(1,j);
            CM_i = alpha_t*(l_t*S_t/(wing_c*S_w));
            CL_i = -alpha_t*S_t/S_w;

            i_t(i,j) = - (180/3.1415)*(CM_AC*CL_alpha + CM_alpha*CL)/(CL_alpha*CM_i - CM_alpha*CL_i); %incidence angle in degrees
   
        end
    end
    %(1,1): fueled w/ retardent, (1,2): fueled without retardent, (2,1):
    %unfueled with retardent, (2,2): unfuled without retardent
    
    v_cruise = plane.data.aero.v_cruise; %(1,1) is wet, (1,2) is dry (in terms of retardent)
    
    
    
    % computing alphas
    alphas = zeros(2,2);
    L = zeros(2,2);
    Weight = plane.data.weight;
    L = [Weight.wet (Weight.wet - Weight.fuel); Weight.dry (Weight.dry - Weight.fuel)];
    for i = 1:2 %looping through fueled and unfueled
        for j = 1:2 %looping through with and without retardent
            q = 0.5*0.00238*v_cruise(1,j)^2;
      
            alphas(i,j) = (180/3.1415)*((L(i,j)/(q*S_w)) + (alpha_t*i_t(i,j)*S_t/S_w) - plane.geo.wing.cl_0)/(alpha_w + (alpha_t*S_t*(1-epsilon_alpha)/S_w));
        end
    end
    
    stall = false;

    for i = 1:2
        for j = 1:2
            if alphas(i,j) > 15
                stall = true;
                break;
            end
            
            if abs(alphas(i,j) - i_t(i,j)) > 15
                stall = true;
                break;
            end
        end
    end
   plane.data.stability.stall = stall;
   plane.data.stability.alphas  = alphas;
    
    %% yaw stability
    
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
    end

   
    
end

