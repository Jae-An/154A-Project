function [plane] = getRandomPlane(plane)

%randomization format
%rand_value = min_value + rand(1)*(max_value - min_value)

%fuselage
plane.geo.body.L = 20 + rand(1)*(100 - 40); %ft, fuselage L
plane.geo.body.W = 5 + rand(1)*(30 - 10); %ft, fuselage width
plane.geo.body.D = 1 + rand(1)*(30 - 10); %ft, fuselage depth

%wing
plane.geo.wing.S = 20 + rand(1)*(1000 - 300); %ft^2, wing area
plane.geo.wing.AR = 1 + rand(1)*(13 - 7); %wing aspect ratio
plane.geo.wing.c = 3 + rand(1)*(12 - 5); %ft, wing chord length
plane.geo.wing.b = (plane.geo.wing.AR * plane.geo.wing.S)^0.5; %ft, wing span length
plane.geo.wing.ThR = 0.12;
plane.geo.wing.TR = 0.3 + rand(1)*(0.4-0.3);
plane.geo.wing.sweep = 0 + rand(1)*(10-0); %degrees, sweep length
plane.geo.wing.cg = 0 + rand(1)*(12-0); %ft, distance from wing leading edge to CG
plane.geo.wing.h_cg = plane.geo.wing.cg/plane.geo.wing.c; %nondimensional, distance from wing leading edge to CG
plane.geo.wing.ac = 0.25*plane.geo.wing.c; %ft, distance from wing leading edge to AC, set to quarter chord
plane.geo.wing.h_ac = plane.geo.wing.ac/plane.geo.wing.c; %nondimensional, distance from wing leading edge to AC

%horizontal tail
plane.geo.h_tail.S = 10 + rand(1)*(300 - 50); %ft^2, h_tail area
plane.geo.h_tail.AR = 1 + rand(1)*(13 - 7); %h_tail aspect ratio
plane.geo.h_tail.c = 3 + rand(1)*(8 - 3); %ft, h_tail chord length
plane.geo.h_tail.b = (plane.geo.h_tail.AR * plane.geo.h_tail.S)^0.5; %ft, h_tail span length
plane.geo.h_tail.ThR = 0.12;
plane.geo.h_tail.TR = 0.3 + rand(1)*(0.4-0.3);
plane.geo.h_tail.sweep = 0 + rand(1)*(15-0); %degrees, sweep length
plane.geo.h_tail.cg = plane.geo.wing.cg + rand(1)*(plane.geo.body.L - plane.geo.wing.cg); %ft, distance from h_tail leading edge to CG
%set to be at least the distance of the wing from cg, to (fuselage_length - wing_Xcg)
plane.geo.h_tail.h_cg = plane.geo.h_tail.cg/plane.geo.wing.c; %nondimensional, distance from h_tail leading edge to CG
plane.geo.h_tail.ac = plane.geo.h_tail.cg + 0.25*plane.geo.h_tail.c; %ft, distance from h_tail leading edge to AC, set to quarter chord
plane.geo.h_tail.h_ac = plane.geo.h_tail.ac/plane.geo.wing.c; %nondimensional, distance from h_tail leading edge to AC


%vertical tail
plane.geo.v_tail.S = 10 + rand(1)*(300 - 30); %ft^2, v_tail area
plane.geo.v_tail.AR = 1 + rand(1)*(10 - 3); %v_tail aspect ratio
plane.geo.v_tail.c = 3 + rand(1)*(8 - 3); %ft, v_tail chord length
plane.geo.v_tail.b = (plane.geo.v_tail.AR * plane.geo.v_tail.S)^0.5; %ft, v_tail span length
plane.geo.v_tail.ThR = 0.12;
plane.geo.v_tail.TR = 0.3 + rand(1)*(0.4-0.3);
plane.geo.v_tail.sweep = 0 + rand(1)*(15-0); %degrees, sweep length
plane.geo.v_tail.cg = plane.geo.h_tail.cg; %ft, distance from v_tail leading edge to CG, set to h_tail value
plane.geo.v_tail.h_cg = plane.geo.h_tail.h_cg; %nondimensional, distance from v_tail leading edge to CG, set to h_tail value
plane.geo.v_tail.ac = plane.geo.h_tail.ac; %ft, distance from v_tail leading edge to AC, set to quarter chord, set to h_tail value
plane.geo.v_tail.h_ac = plane.geo.h_tail.h_ac; %nondimensional, distance from v_tail leading edge to AC, set to h_tail value


%aero









