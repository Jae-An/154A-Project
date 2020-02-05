%aerodynamics solver function
function [CL_dry, CL_wet, CD_dry, CD_wet, CD0,CDi_dry,CDi_wet CL_alpha] = aerodynamics(plane)

wing = plane.geo.wing;
h_tail = plane.geo.h_tail;
v_tail = plane.geo.v_tail;
fuselage = plane.geo.body;
weight = plane.weight;
v_stall = plane.requirements.v_stall; %v_ref set to stall velocity, ft/s
v_max = plane.requirements.v_max;
v_ref = linspace(v_stall, v_max);

air_density = 0.00238;      %slug/ft3
viscocity = 3.73*10^-7;     %slug/ft/s
e_tail = 0.3;
e_wing = 0.3;

CL_dry = zeros(100,1);
CL_wet = CL_dry;
CD_dry = CL_dry;
CD_wet = CL_dry;
CD0 = CL_dry;
CDi_dry = CL_dry;
CDi_wet = CL_dry;

for i = 1:100
    %% overall CLs
    CL_dry(i) = weight.weight_dry/((0.5*air_density*v_ref(i)^2)*wing.S);    %determines dry CL total for reference speed
    CL_wet(i) = weight.weight_wet/((0.5*air_density*v_ref(i)^2)*wing.S);    %determines wet CL total for reference speed
    
    %%
    %**** NEED TO DETERMINE WING AND TAIL CL'S INDEPENDENTLY ****
    

    %% CD0 (parasite) estimation (from slide 93, drag lecture, MAE 154s material)
    % computing Cf

    Re = air_density*v_ref(i)*wing.b/viscocity;
    Mach = v_ref(i)/1125;                      %VMIN MUST BE IN FT/S
    Cf = 0.455/((log10(Re)^2.58)*(1+0.144*Mach^2)^0.65);

    %compute K's
    K_wing = [1 + (0.6/wing.h_cg)*(wing.thickness/wing.chord) + 100*(wing.thickness/wing.chord)^4]*...
             [1.24*(Mach^0.18)*cos(wing.sweep)^0.28];

    K_horizontal_tail = [1 + (0.6/h_tail.h_cg)*(h_tail.thickness/h_tail.chord) + 100*(h_tail.thickness/h_tail.chord)^4]*...
             [1.24*(Mach^0.18)*cos(h_tail.sweep)^0.28];
    K_vertical_tail = [1 + (0.6/v_tail.h_cg)*(v_tail.thickness/v_tail.chord) + 100*(v_tail.thickness/v_tail.chord)^4]*...
             [1.24*(Mach^0.18)*cos(v_tail.sweep)^0.28];
    f = fuselage.length/fuselage.width;
    K_fuselage = (1 + (60/f^3) + (f/400));

    %Q's
    Q_wing = 1;
    Q_tail = 1.08;


    CD0_wing = K_wing*Q_wing;
    CD0_h_tail = K_horizontal_tail*Q_tail*Cf*h_tail.S/wing.S;
    CD0_v_tail = K_vertical_tail*Q_tail*Cf*v_tail.S/wing.S;
    CD0_fuselage = K_fuselage*(fuselage.length*3.1415*fuselage.width^2)*Cf/wing.S;

    CD0(i) = CD0_wing + CD0_h_tail + CD0_v_tail + CD0_fuselage;
   % CDi(i) = ((CL_wing^2)/(3.1415*wing.AR*e_wing)) +
   % ((CL_tail^2)/(3.1415*tail.AR*e_tail)); %need to figure out how to
   % solve for CL_wing and CL_tail
   
   %% induced drag
    CDi_dry(i) = ((CL_dry^2)/(3.1415*wing.AR*e_wing)); %dry mass induced drag
    CDi_wet(i) = ((CL_wet^2)/(3.1415*wing.AR*e_wing)); %wet mass induced drag

    CD_dry(i) = CDi_dry(i) + CD0(i);                   %dry mass total drag
    CD_wet(i) = CDi_wet(i) + CD0(i);                   %
end


