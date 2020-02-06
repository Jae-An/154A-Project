%aerodynamics solver function

%function [CL_dry, CL_wet, CD_dry, CD_wet, CD0,CDi_dry,CDi_wet CL_alpha] = aerodynamics(plane)

function plane = aerodynamics(plane)


wing = plane.geo.wing;
h_tail = plane.geo.h_tail;
v_tail = plane.geo.v_tail;
body = plane.geo.body;
weight = plane.data.weight;
v_stall = plane.data.requirements.v_stall; %v_ref set to stall velocity, ft/s
v_max = plane.data.requirements.v_max;

v_ref = linspace(v_stall, v_max);

air_density = 0.00200;      %slug/ft3, 20,000 ft.
viscosity = 3.324*10^-7;     %slug/ft/s, 20,000 ft.
e_tail = 0.3;
e_wing = 0.3;

CL = zeros(100,2); % 1st column is wet(retardent), 2nd is dry(no retardent)
CD = zeros(100,2);
CD0 = zeros(100,1);
CDi = zeros(100,2);

for i = 1:100
    %% overall CLs
    CL(i,2) = weight.dry/((0.5*air_density*v_ref(i)^2)*wing.S);    %determines dry CL total for reference speed
    CL(i,1) = weight.wet/((0.5*air_density*v_ref(i)^2)*wing.S);    %determines wet CL total for reference speed

    
    %%
    %**** NEED TO DETERMINE WING AND TAIL CL'S INDEPENDENTLY ****
    

    %% CD0 (parasite) estimation (from slide 93, drag lecture, MAE 154s material)
    % computing Cf

    Re = air_density*v_ref(i)*wing.c/viscosity;
    Mach = v_ref(i)/1125;                      %v_ref MUST BE IN FT/S
    Cf = 0.455/((log10(Re)^2.58)*(1+0.144*Mach^2)^0.65);

    %compute K's
    K_wing = [1 + (0.6/wing.h_t)*(wing.ThR) + 100*(wing.ThR)^4]*...
             [1.34*(Mach^0.18)*cos(wing.sweep*pi/180)^0.28];

    K_horizontal_tail = [1 + (0.6/h_tail.h_t)*(h_tail.ThR) + 100*(h_tail.ThR)^4]*...
             [1.34*(Mach^0.18)*cos(h_tail.sweep*pi/180)^0.28];
    K_vertical_tail = [1 + (0.6/v_tail.h_t)*(v_tail.ThR) + 100*(v_tail.ThR)^4]*...
             [1.34*(Mach^0.18)*cos(v_tail.sweep*pi/180)^0.28];
    f = body.L/body.W;
    K_fuselage = (1 + (60/f^3) + (f/400));

    %Q's
    Q_wing = 1;
    Q_tail = 1.08;
    

    CD0_wing = K_wing*Q_wing*Cf*wing.S_wet/wing.S;
    CD0_h_tail = K_horizontal_tail*Q_tail*Cf*h_tail.S_wet/wing.S;
    CD0_v_tail = K_vertical_tail*Q_tail*Cf*v_tail.S_wet/wing.S;
    CD0_fuselage = K_fuselage*Cf*(body.L*body.W*body.D)/wing.S;

    CD0(i) = CD0_wing + CD0_h_tail + CD0_v_tail + CD0_fuselage;
   % CDi(i) = ((CL_wing^2)/(3.1415*wing.AR*e_wing)) +
   % ((CL_tail^2)/(3.1415*tail.AR*e_tail)); %need to figure out how to
   % solve for CL_wing and CL_tail

   
   %% induced drag
    CDi(i,2) = ((CL(i,2)^2)/(pi*wing.AR*e_wing)); %dry mass induced drag
    CDi(i,1) = ((CL(i,1)^2)/(pi*wing.AR*e_wing)); %wet mass induced drag

    CD(i,2) = CDi(i,2) + CD0(i);                   %dry mass total drag
    CD(i,1) = CDi(i,1) + CD0(i);                   %
    
    
end



if ~isreal(CD)
    error =  'imaginary CD'
end
if ~isreal(CL)
    error = 'imaginary CL'
end

plane.data.aero.CL = CL;
plane.data.aero.CD = CD;
%plane.data.CL_alpha = CL_alpha;
plane.data.aero.CDi = CDi;
plane.data.aero.CD0 = CD0;
% 
;
% [wet_min_Cd, wet_cruise_speed_index] = min(CD(:,1));
% wet_cruise_speed = v_ref(wet_cruise_speed_index);
% plane.data.performance.wet_cruise_speed = wet_cruise_speed;
% 
% [dry_min_Cd, dry_cruise_speed_index] = min(CD(:,2));
% dry_cruise_speed = v_ref(dry_cruise_speed_index);
% plane.data.performance.dry_cruise_speed = dry_cruise_speed;
