function [plane] = getRandomPlane(plane,bestPlane,i)
body = bestPlane.geo.body;
wing = bestPlane.geo.wing;
htail = bestPlane.geo.h_tail;
vtail = bestPlane.geo.v_tail;

%randnomization format
%randn_value = min_value + randn(1)*(max_value - min_value)
V_tank = 256; %ft3 volume of retardent tank, sized to fit 16000 lbs of retardent
%fuselage
plane.geo.body.W = body.W + randn(1)*body.W/(3*10^(i/3)); %ft, fuselage width
plane.geo.body.D = plane.geo.body.W; %ft, fuselage depth, for a circular cross section plane
plane.geo.body.L = body.L + randn(1)*body.L/(3*10^(i/3)); %ft, fuselage L
plane.geo.body.tank_length = V_tank / (pi*(plane.geo.body.D/4)^2);%[(V_tank - (8*3.1415/3)*(plane.geo.body.D/2)^3)/(3.1415*(plane.geo.body.D/2)^2)]+plane.geo.body.D;

%% wing
plane.geo.wing.cl_a = 6.88; %Cl/rad for NACA 6412 airfoil
plane.geo.wing.cl_0 = 0.7626; %Cl for 0 AOA for NACA 6412 airfoil
plane.geo.wing.TR = wing.TR + randn(1)*wing.TR/(3*10^(i/3)); % taper ratio
plane.geo.wing.S = wing.S + randn(1)*wing.S/(3*10^(i/3)); %ft^2, wing area
plane.geo.wing.b = wing.b + randn(1)*wing.b/(3*10^(i/3)); %ft, wingspan
plane.geo.wing.AR = plane.geo.wing.b^2 / plane.geo.wing.S; %wing aspect ratio
plane.geo.wing.c = 2*plane.geo.wing.S / (plane.geo.wing.b*(1+plane.geo.wing.TR)); %ft, wing chord length
plane.geo.wing.ThR = 0.12; % thickness ratio
plane.geo.wing.sweep = wing.sweep + randn(1)*wing.sweep/(3*10^(i/3)); %degrees, sweep length
plane.geo.wing.S_wet = plane.geo.wing.S*(1.977 + 0.52*plane.geo.wing.ThR); %ft^2, wetted area formula from http://www.ipublishing.co.in/jarvol1no12010/EIJAER2011.pdf
plane.geo.wing.h_t = 0.301; %nondimensional distance to maximum thickness

plane.geo.wing.LE = wing.LE + randn(1)*wing.LE/(3*10^(i/3));
% need to define distance from nosetip to wing edge
plane.geo.wing.h_ac = 0.25; %nondimensional, distance from wing leading edge to AC
plane.geo.wing.ac = plane.geo.wing.h_ac*plane.geo.wing.c; %ft, distance from wing leading edge to AC, set to quarter chord

%% horizontal tail
%%%%%% We're using the same airfoil for the tail? %%%%%%%%%%%
plane.geo.h_tail.cl_a = 6.88; %Cl/rad for NACA 6412 airfoil
plane.geo.h_tail.cl_0 = 0.7626; %Cl for 0 AOA for NACA 6412 airfoil
plane.geo.h_tail.TR = htail.TR + randn(1)*htail.TR/(3*10^(i/3));
Sht_Sw = htail.S/wing.S + randn(1)*(htail.S/wing.S)/(3*10^(i/3));
plane.geo.h_tail.S = Sht_Sw*plane.geo.wing.S; %ft^2, h_tail area
plane.geo.h_tail.AR = htail.AR + randn(1)*htail.AR/(3*10^(i/3)); %h_tail aspect ratio
plane.geo.h_tail.b = (plane.geo.h_tail.S * plane.geo.h_tail.AR)^0.5; %ft, h_tail span length
plane.geo.h_tail.c = 2*plane.geo.h_tail.S / (plane.geo.h_tail.b*(1+plane.geo.h_tail.TR)); %ft, h_tail chord length
plane.geo.h_tail.ThR = 0.12;
plane.geo.h_tail.sweep = htail.sweep + randn(1)*htail.sweep/(3*10^(i/3)); %degrees, sweep length
plane.geo.h_tail.S_wet = plane.geo.h_tail.S*(1.977 + 0.52*plane.geo.h_tail.ThR); %ft^2, wetted area formula from http://www.ipublishing.co.in/jarvol1no12010/EIJAER2011.pdf
plane.geo.h_tail.h_t = 0.301; %nondimensional distance to maximum thickness

wing = plane.geo.wing;
h_tail_minLE = wing.LE + wing.c; % min location is at least end of wing
h_tail_maxLE = plane.geo.body.L - plane.geo.h_tail.c; % max location has end of tail = end of body
plane.geo.h_tail.LE = htail.LE + randn(1)*htail.LE/(3*10^(i/3)); %Dist from nose to LE of htail

plane.geo.h_tail.ac = (plane.geo.h_tail.LE - plane.geo.wing.LE) + 0.25*plane.geo.h_tail.c/plane.geo.wing.c; %ft, distance from wing leading edge to htail AC, set to quarter chord
plane.geo.h_tail.h_ac = plane.geo.h_tail.ac/plane.geo.wing.c; %nondimensional, distance from wing leading edge to htail AC


%% vertical tail
plane.geo.v_tail.ThR = 0.12;
plane.geo.v_tail.TR =  vtail.TR + randn(1)*vtail.TR/(3*10^(i/3));
Svt_Sw = vtail.S/wing.S + randn(1)*(vtail.S/wing.S)/(3*10^(i/3));
plane.geo.v_tail.S = Svt_Sw * plane.geo.wing.S; %ft^2, v_tail area
plane.geo.v_tail.AR = vtail.AR + randn(1)*vtail.AR/(3*10^(i/3)); %v_tail aspect ratio
plane.geo.v_tail.b = ((plane.geo.v_tail.S*plane.geo.v_tail.AR)^0.5)/2; %ft, v_tail span length
plane.geo.v_tail.c = 2*plane.geo.v_tail.S / (plane.geo.v_tail.b*(1+plane.geo.v_tail.TR)); %ft, v_tail chord length
plane.geo.v_tail.sweep = vtail.sweep + randn(1)*vtail.sweep/(3*10^(i/3)); %degrees, sweep length
plane.geo.v_tail.S_wet = plane.geo.v_tail.S*(1.977 + 0.52*plane.geo.v_tail.ThR); %ft^2, wetted area formula from http://www.ipublishing.co.in/jarvol1no12010/EIJAER2011.pdf
plane.geo.v_tail.h_t = 0.301; %nondimensional distance to maximum thickness

v_tail_minLE = wing.LE + wing.c; % min location is end of wing
v_tail_maxLE = plane.geo.body.L - plane.geo.v_tail.c; % max location has end of tail = end of body
plane.geo.v_tail.LE = vtail.LE + randn(1)*vtail.LE/(3*10^(i/3)); %Dist from nose to LE of vtail

plane.geo.v_tail.ac = (plane.geo.v_tail.LE - plane.geo.wing.LE) + 0.25*plane.geo.v_tail.c/plane.geo.wing.c; %ft, distance from wing leading edge to vtail AC, set to quarter chord
plane.geo.v_tail.h_ac = plane.geo.v_tail.ac/plane.geo.wing.c; %nondimensional, distance from wing leading edge to vtail AC
plane.geo.v_tail.cl_a = 0.1*180/3.1415; %vertical tail lift curve slope

%% nacelle
plane.geo.nacelle.L = 6; % Length of each nacelle (engine)
plane.geo.nacelle.D = 1.585; % Diameter of nacelle (engine)
plane.geo.nacelle.S_wet = 3.4*plane.geo.nacelle.L*plane.geo.nacelle.D;
plane.prop.fuel_mass = bestPlane.prop.fuel_mass + randn(1)*bestPlane.prop.fuel_mass/(3*10^(i/3));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PREVIOUS CODE %%%%%%%%%%%%%%%%%%
% function [plane] = getRandomPlane(plane)
% 
% %randomization format
% %rand_value = min_value + rand(1)*(max_value - min_value)
% V_tank = 256; %ft3 volume of retardent tank, sized to fit 16000 lbs of retardent
% %fuselage
% plane.geo.body.W = 2 + rand(1)*(6 - 2); %ft, fuselage width
% plane.geo.body.D = plane.geo.body.W; %ft, fuselage depth, for a circular cross section plane
% plane.geo.body.L = 50 + rand(1)*(120 - 50); %ft, fuselage L
% tank_length = [(V_tank - (8*3.1415/3)*(plane.geo.body.D/2)^3)/(3.1415*(plane.geo.body.D/2)^2)]+plane.geo.body.D;
% 
% %% wing
% plane.geo.wing.cl_a = 6.88; %Cl/rad for NACA 6412 airfoil
% plane.geo.wing.cl_0 = 0.7626; %Cl for 0 AOA for NACA 6412 airfoil
% plane.geo.wing.TR = 0.1 + rand(1)*(1 - 0.1); % taper ratio
% plane.geo.wing.S = 500 + rand(1)*(1200 - 500); %ft^2, wing area
% plane.geo.wing.b = 50 + rand(1)*(150 - 50); %ft, wingspan
% plane.geo.wing.AR = plane.geo.wing.b^2 / plane.geo.wing.S; %wing aspect ratio
% plane.geo.wing.c = 2*plane.geo.wing.S / (plane.geo.wing.b*(1+plane.geo.wing.TR)); %ft, wing chord length
% plane.geo.wing.ThR = 0.12; % thickness ratio
% plane.geo.wing.sweep = 0 + rand(1)*(5-0); %degrees, sweep length
% plane.geo.wing.S_wet = plane.geo.wing.S*(1.977 + 0.52*plane.geo.wing.ThR); %ft^2, wetted area formula from http://www.ipublishing.co.in/jarvol1no12010/EIJAER2011.pdf
% plane.geo.wing.h_t = 0.301; %nondimensional distance to maximum thickness
% 
% plane.geo.wing.LE = (0.1*plane.geo.body.L) + rand(1)*(plane.geo.body.L*(0.75-0.05));
% % need to define distance from nosetip to wing edge
% plane.geo.wing.h_ac = 0.25; %nondimensional, distance from wing leading edge to AC
% plane.geo.wing.ac = plane.geo.wing.h_ac*plane.geo.wing.c; %ft, distance from wing leading edge to AC, set to quarter chord
% 
% %% horizontal tail
% %%%%%% We're using the same airfoil for the tail? %%%%%%%%%%%
% plane.geo.h_tail.cl_a = 6.88; %Cl/rad for NACA 6412 airfoil
% plane.geo.h_tail.cl_0 = 0.7626; %Cl for 0 AOA for NACA 6412 airfoil
% plane.geo.h_tail.TR = 0.1 + rand(1)*(1 - 0.1);
% Sht_Sw = 0.1 + rand(1)*(0.75 - 0.1);
% plane.geo.h_tail.S = Sht_Sw*plane.geo.wing.S; %ft^2, h_tail area
% plane.geo.h_tail.AR = 4 + rand(1)*(8 - 4); %h_tail aspect ratio
% plane.geo.h_tail.b = (plane.geo.h_tail.S * plane.geo.h_tail.AR)^0.5; %ft, h_tail span length
% plane.geo.h_tail.c = 2*plane.geo.h_tail.S / (plane.geo.h_tail.b*(1+plane.geo.h_tail.TR)); %ft, h_tail chord length
% plane.geo.h_tail.ThR = 0.12;
% plane.geo.h_tail.sweep = 0 + rand(1)*(5-0); %degrees, sweep length
% plane.geo.h_tail.S_wet = plane.geo.h_tail.S*(1.977 + 0.52*plane.geo.h_tail.ThR); %ft^2, wetted area formula from http://www.ipublishing.co.in/jarvol1no12010/EIJAER2011.pdf
% plane.geo.h_tail.h_t = 0.301; %nondimensional distance to maximum thickness
% 
% wing = plane.geo.wing;
% h_tail_minLE = wing.LE + wing.c; % min location is at least end of wing
% h_tail_maxLE = plane.geo.body.L - plane.geo.h_tail.c; % max location has end of tail = end of body
% plane.geo.h_tail.LE = h_tail_minLE + rand(1)*(h_tail_maxLE - h_tail_minLE); %Dist from nose to LE of htail
% 
% plane.geo.h_tail.ac = (plane.geo.h_tail.LE - plane.geo.wing.LE) + 0.25*plane.geo.h_tail.c/plane.geo.wing.c; %ft, distance from wing leading edge to htail AC, set to quarter chord
% plane.geo.h_tail.h_ac = plane.geo.h_tail.ac/plane.geo.wing.c; %nondimensional, distance from wing leading edge to htail AC
% 
% 
% %% vertical tail
% plane.geo.v_tail.ThR = 0.12;
% plane.geo.v_tail.TR =  0.1 + rand(1)*(1 - 0.1);
% Svt_Sw = 0.05 + rand(1)*(0.75 - 0.05);
% plane.geo.v_tail.S = Svt_Sw * plane.geo.wing.S; %ft^2, v_tail area
% plane.geo.v_tail.AR = 2 + rand(1)*(7 - 2); %v_tail aspect ratio
% plane.geo.v_tail.b = ((plane.geo.v_tail.S*plane.geo.v_tail.AR)^0.5)/2; %ft, v_tail span length
% plane.geo.v_tail.c = 4*plane.geo.v_tail.S / (plane.geo.v_tail.b*(1+plane.geo.v_tail.TR)); %ft, v_tail chord length
% plane.geo.v_tail.sweep = 0 + rand(1)*(15-0); %degrees, sweep length
% plane.geo.v_tail.S_wet = plane.geo.v_tail.S*(1.977 + 0.52*plane.geo.v_tail.ThR); %ft^2, wetted area formula from http://www.ipublishing.co.in/jarvol1no12010/EIJAER2011.pdf
% plane.geo.v_tail.h_t = 0.301; %nondimensional distance to maximum thickness
% 
% v_tail_minLE = wing.LE + wing.c; % min location is end of wing
% v_tail_maxLE = plane.geo.body.L - plane.geo.v_tail.c; % max location has end of tail = end of body
% plane.geo.v_tail.LE = v_tail_minLE + rand(1)*(v_tail_maxLE - v_tail_minLE); %Dist from nose to LE of vtail
% 
% plane.geo.v_tail.ac = (plane.geo.v_tail.LE - plane.geo.wing.LE) + 0.25*plane.geo.v_tail.c/plane.geo.wing.c; %ft, distance from wing leading edge to vtail AC, set to quarter chord
% plane.geo.v_tail.h_ac = plane.geo.v_tail.ac/plane.geo.wing.c; %nondimensional, distance from wing leading edge to vtail AC
% plane.geo.v_tail.cl_a = 0.1*180/3.1415; %vertical tail lift curve slope
% 
% %% nacelle
% plane.geo.nacelle.L = 6; % Length of each nacelle (engine)
% plane.geo.nacelle.D = 1.585; % Diameter of nacelle (engine)
% plane.geo.nacelle.S_wet = 3.4*plane.geo.nacelle.L*plane.geo.nacelle.D;

