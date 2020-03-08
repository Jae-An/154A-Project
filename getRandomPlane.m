function [plane] = getRandomPlane(plane)

%randomization format
%rand_value = min_value + rand(1)*(max_value - min_value)
V_tank = 256; %ft3 volume of retardent tank, sized to fit 16000 lbs of retardent
%fuselage
plane.geo.body.W = 5 + rand(1)*(10 - 5); %ft, fuselage width
plane.geo.body.D = plane.geo.body.W; %ft, fuselage depth, for a circular cross section plane
plane.geo.body.L = 35 + rand(1)*(50 - 20); %ft, fuselage L

tank_length = [(V_tank - (8*3.1415/3)*(plane.geo.body.D/2)^3)/(3.1415*(plane.geo.body.D/2)^2)]+plane.geo.body.D;

%% wing
plane.geo.wing.S = 350 + rand(1)*(2000 - 350); %ft^2, wing area
plane.geo.wing.AR = 5 + rand(1)*(25 - 5); %wing aspect ratio
plane.geo.wing.c = ((16*plane.geo.wing.S)/(plane.geo.wing.AR*3.1415^2))^0.5; %ft, wing chord length
plane.geo.wing.b = (plane.geo.wing.AR * plane.geo.wing.S)^0.5; %ft, wing span length
plane.geo.wing.ThR = 0.12; % thickness ratio
plane.geo.wing.TR = 0.57; % taper ratio
plane.geo.wing.sweep = 0 + rand(1)*(5-0); %degrees, sweep length
plane.geo.wing.cg = 4 + rand(1)*(12-0); %ft, distance from wing leading edge to CG
plane.geo.wing.h_cg = plane.geo.wing.cg/plane.geo.wing.c; %nondimensional, distance from wing leading edge to CG
plane.geo.wing.ac = 0.25*plane.geo.wing.c; %ft, distance from wing leading edge to AC, set to quarter chord

plane.geo.wing.h_ac = 0.25; %nondimensional, distance from wing leading edge to AC
plane.geo.wing.lnw = (0.1*plane.geo.body.L) + rand(1)*(0.25*plane.geo.body.L);
% need to define distance from nosetip to wing edge

plane.geo.wing.cl_a = 6.88; %Cl/rad for NACA 6412 airfoil
plane.geo.wing.cl_0 = 0.7626; %Cl for 0 AOA for NACA 6412 airfoil
plane.geo.wing.h_t = 0.301; %Nondimensional distance to maximum thickness
plane.geo.wing.S_wet = plane.geo.wing.S*(1.977 + 0.52*plane.geo.wing.ThR); %ft^2, wetted area formula from http://www.ipublishing.co.in/jarvol1no12010/EIJAER2011.pdf


%% horizontal tail
plane.geo.h_tail.cl_a = 6.88; %Cl/rad for NACA 6412 airfoil
plane.geo.h_tail.cl_0 = 0.7626; %Cl for 0 AOA for NACA 6412 airfoil

St_Sw = 0.05 + rand(1)*(0.5 - 0.05);
plane.geo.h_tail.S = St_Sw*plane.geo.wing.S; %ft^2, h_tail area
plane.geo.h_tail.AR = 4 + rand(1)*(8 - 4); %h_tail aspect ratio
plane.geo.h_tail.c = ((16*plane.geo.h_tail.S)/(plane.geo.h_tail.AR*3.1415^2))^0.5; %ft, h_tail chord length
plane.geo.h_tail.b = (plane.geo.h_tail.AR * plane.geo.h_tail.S)^0.5; %ft, h_tail span length
plane.geo.h_tail.ThR = 0.12;
plane.geo.h_tail.TR = 0.57;
plane.geo.h_tail.sweep = 0 + rand(1)*(5-0); %degrees, sweep length
plane.geo.h_tail.S_wet = plane.geo.h_tail.S*(1.977 + 0.52*plane.geo.h_tail.ThR); %ft^2, wetted area formula from http://www.ipublishing.co.in/jarvol1no12010/EIJAER2011.pdf
%%

%%%%%%%%%%%% FIX ALL THIS %%%%%%%%%%
plane.geo.h_tail.cg = plane.geo.body.L - plane.geo.wing.lnw - plane.geo.wing.cg - 8; %ft, distance from h_tail leading edge to CG
plane.geo.h_tail.h_cg = plane.geo.h_tail.cg/plane.geo.wing.c; %nondimensional, distance from h_tail leading edge to CG
plane.geo.h_tail.ac = plane.geo.wing.cg + plane.geo.h_tail.cg + 0.25*plane.geo.h_tail.c/plane.geo.wing.c; %ft, distance from wing leading edge to AC, set to quarter chord
plane.geo.h_tail.h_ac = plane.geo.h_tail.ac/plane.geo.wing.c; %nondimensional, distance from wing leading edge to AC
plane.geo.h_tail.h_t = 0.301; %nondimensional distance to maximum thickness
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%maybe fixed rn


%% vertical tail
plane.geo.v_tail.S = 10 + rand(1)*(300 - 30); %ft^2, v_tail area
plane.geo.v_tail.AR = 1 + rand(1)*(10 - 3); %v_tail aspect ratio
plane.geo.v_tail.c = ((4*3.1415*plane.geo.v_tail.S)^2/plane.geo.v_tail.AR)^0.5; %ft, v_tail chord length
plane.geo.v_tail.b = (plane.geo.v_tail.AR * plane.geo.v_tail.S)^0.5; %ft, v_tail span length
plane.geo.v_tail.ThR = 0.12;
plane.geo.v_tail.TR = 0.57;
plane.geo.v_tail.sweep = 0 + rand(1)*(15-0); %degrees, sweep length
plane.geo.v_tail.cg = plane.geo.h_tail.cg; %ft, distance from v_tail leading edge to CG, set to h_tail value
plane.geo.v_tail.h_cg = plane.geo.h_tail.h_cg; %nondimensional, distance from v_tail leading edge to CG, set to h_tail value
plane.geo.v_tail.ac = plane.geo.h_tail.ac; %ft, distance from v_tail leading edge to AC, set to quarter chord, set to h_tail value
plane.geo.v_tail.h_ac = plane.geo.h_tail.h_ac; %nondimensional, distance from v_tail leading edge to AC, set to h_tail value
plane.geo.v_tail.h_t = 0.301; %nondimensional distance to maximum thickness
plane.geo.v_tail.S_wet = plane.geo.v_tail.S*(1.977 + 0.52*plane.geo.v_tail.ThR); %ft^2, wetted area formula from http://www.ipublishing.co.in/jarvol1no12010/EIJAER2011.pdf
%aero









