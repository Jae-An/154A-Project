%aerodynamics solver functionv (made for stability (stall) calcs)
function [CL, CM_ac, rho, v] = getAero(plane, W, alt, v_ref)
% alt denotes altitude.
% alt = 1 goes to sea level conditions
% alt = 2 goes to 20,000 ft conditions
    switch alt
        case 1
            rho = 0.00238; %quantities at sea
            mu = 3.737*10^-7;
            v_sound = 1116;
            CM_ac = -0.135;
        case 2
            rho = 0.001267;      %slug/ft3, 20,000 ft.
            mu = 3.324*10^-7;     %slug/ft/s, 20,000 ft.
            v_sound = 968;
            CM_ac = -0.13;
        otherwise
            rho = 0.00238; %quantities at sea
            mu = 3.737*10^-7;
            v_sound = 1116;
            CM_ac = -0.135;
    end
    
    wing = plane.geo.wing;
    h_tail = plane.geo.h_tail;
    v_tail = plane.geo.v_tail;
    body = plane.geo.body;
    
    e_wing = 0.85;

    CL_ref = zeros(100,1); % 1st column is wet(retardent), 2nd is dry(no retardent)
    CD_ref = zeros(100,1);
    CD0_ref = zeros(100,1); % 2nd Column is ground conditions
    CDi_ref = zeros(100,1); 
    D_ref = zeros(100,1);
    L_ref = zeros(100,1);
    RE_ref = zeros(100,1);
    
    %prop stuff
    eta = plane.prop.eta_p; % eta and hp same for all planes so I just used the first one
    hp = plane.prop.hp;
    thrust = (hp * 550 * eta) ./ v_ref;
    thrust = thrust.';
    plane.prop.thrust = thrust;
    Difference = zeros(100,1);

    for i = 1:length(v_ref)
        %% Overall CLs
            CL_ref(i) = W / ((0.5*rho*v_ref(i)^2)*wing.S);

        %% CD0 (parasite) estimation (from slide 93, drag lecture, MAE 154s material)
        % only calculated once rather than twice
        % computing Cf
        Re = rho*v_ref(i)*wing.c/mu;
        Mach = v_ref(i)/v_sound;                      %v_ref MUST BE IN FT/S
        Cf = 0.455/((log10(Re)^2.58)*(1+0.144*Mach^2)^0.65);

        %compute K's
        K_wing = (1 + (0.6/wing.h_t)*(wing.ThR) + 100*(wing.ThR)^4)*...
                (1.34*(Mach^0.18)*cos(wing.sweep*pi/180)^0.28);
        K_horizontal_tail = (1 + (0.6/h_tail.h_t)*(h_tail.ThR) + 100*(h_tail.ThR)^4)*...
                (1.34*(Mach^0.18)*cos(h_tail.sweep*pi/180)^0.28);
        K_vertical_tail = (1 + (0.6/v_tail.h_t)*(v_tail.ThR) + 100*(v_tail.ThR)^4)*...
                (1.34*(Mach^0.18)*cos(v_tail.sweep*pi/180)^0.28);
        f_fuselage = body.L/body.W;
        K_fuselage = (1 + (60/f_fuselage^3) + (f_fuselage/400));
        f_nacelle = plane.geo.nacelle.L/plane.geo.nacelle.D;
        K_nacelle = 1 + 0.35/f_nacelle;

        %Q's
        Q_wing = 1;
        Q_tail = 1.08;
        Q_fuselage = 1;
        Q_nacelle = 1.5; %if mounted less than 1 diameter away, then 1.3

        CD0_wing = K_wing*Q_wing*Cf*wing.S_wet/wing.S;
        CD0_h_tail = K_horizontal_tail*Q_tail*Cf*h_tail.S_wet/wing.S;
        CD0_v_tail = K_vertical_tail*Q_tail*Cf*v_tail.S_wet/wing.S;
        CD0_fuselage = K_fuselage*Q_fuselage*Cf*(pi*body.L*body.D)/wing.S;
        CD0_nacelle = K_nacelle*Q_nacelle*Cf*plane.geo.nacelle.S_wet/wing.S;

        CD0_ref(i) = CD0_wing + CD0_h_tail + CD0_v_tail + CD0_fuselage + 2*CD0_nacelle;

        %% induced drag
        CDi_ref(i) = ((CL_ref(i)^2)/(pi*wing.AR*e_wing));    %induced drag
        CD_ref(i) = CDi_ref(i) + CD0_ref(i);                   %total drag
        D_ref(i) = 0.5*rho*v_ref(i)^2*CD_ref(i)*wing.S;   %drag force values for dry mass 
        L_ref(i) = 0.5*rho*v_ref(i)^2*CL_ref(i)*wing.S;   %dry mass lift force values
        RE_ref(i) = Re;

        %% Difference between thrust and drag
        Difference(i) = thrust(i) - D_ref(i);

    end                                                   
    
    [~, maxDiff_index] = max(Difference);
    CL = CL_ref(maxDiff_index);
    CD = CD_ref(maxDiff_index);
    v = v_ref(maxDiff_index);
end

