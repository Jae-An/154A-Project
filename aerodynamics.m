%aerodynamics solver function
function [CL, CD0,CDi, CL_alpha] = aerodynamics(plane)

wing = plane.geo.wing;
h_tail = plane.geo.h_tail;
v_tail = plane.geo.v_tail;
fuselage = plane.geo.body;
weight = plane.weights.weight_total;
v_stall = plane.requirements.v_stall; %v_ref set to stall velocity, ft/s
v_max = plane.requirements.v_max;
v_ref = linspace(v_stall, v_max);

air_density = 0.00238;      %slug/ft3
viscocity = 3.73*10^-7;     %slug/ft/s
e_tail = 0.3;
e_wing = 0.3;

CL = zeros(100,1);
CDP = CL;
CDi = CL;
CD = CL;
for i = 1:100
    %% overall CL
    CL(i) = weight/((0.5*air_density*v_ref(i)^2)*wing.S); %determines CL max
    
    %%
    %**** NEED TO DETERMINE WING AND TAIL CL'S INDEPENDENTLY ****
    

    %% CD estimation (from slide 93, drag lecture, MAE 154s material)
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


    CDP_wing = K_wing*Q_wing;
    CDP_h_tail = K_horizontal_tail*Q_tail*Cf*h_tail.S/wing.S;
    CDP_v_tail = K_vertical_tail*Q_tail*Cf*v_tail.S/wing.S;
    CDP_fuselage = K_fuselage*(body.length*3.1415*body*width^2)*Cf/wing.S;

    CDP(i) = CDP_wing + CDP_h_tail + CDP_v_tail + CDP_fuselage;
   % CDi(i) = ((CL_wing^2)/(3.1415*wing.AR*e_wing)) +
   % ((CL_tail^2)/(3.1415*tail.AR*e_tail)); %need to figure out how to
   % solve for CL_wing and CL_tail
    CDi(i) = ((CL^2)/(3.1415*wing.AR*e_wing));
    CD(i) = CDi(i) + CDP(i);
    
    
end

CD0 = CDP;
