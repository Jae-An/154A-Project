function [plane] = getRandomPlaneOld(plane)



%randomization format
%rand_value = min_value + rand(1)*(max_value - min_value)
V_tank = 256; %ft3 volume of retardent tank, sized to fit 16000 lbs of retardent
%fuselage
plane.geo.body.W = 5 + rand()*(18 - 5); %ft, fuselage width
plane.geo.body.D = plane.geo.body.W; %ft, fuselage depth, for a circular cross section plane
plane.geo.body.L = 30 + rand()*(80 - 30); %ft, fuselage L
plane.geo.body.tank_length = V_tank / (pi*(plane.geo.body.D/4)^2);%[(V_tank - (8*3.1415/3)*(plane.geo.body.D/2)^3)/(3.1415*(plane.geo.body.D/2)^2)]+plane.geo.body.D;


%% wing
plane.geo.wing.cl_a = 6.88; %Cl/rad for NACA 6412 airfoil
plane.geo.wing.cl_0 = 0.7626; %Cl for 0 AOA for NACA 6412 airfoil
plane.geo.wing.TR = 0.34; % taper ratio
plane.geo.wing.S = 450 + rand()*(900 - 450); %ft^2, wing area
plane.geo.wing.AR = 5 + rand()*(15 - 5); %wing aspect ratio
plane.geo.wing.b = (plane.geo.wing.S * plane.geo.wing.AR )^0.5; %ft, wing span length
plane.geo.wing.c = 2*plane.geo.wing.S/plane.geo.wing.b/(1+plane.geo.wing.TR); %ft, wing chord length

plane.geo.wing.ThR = 0.12; % thickness ratio
plane.geo.wing.sweep = 0 + rand()*(15-0); %degrees, sweep length
plane.geo.wing.S_wet = plane.geo.wing.S*(1.977 + 0.52*plane.geo.wing.ThR); %ft^2, wetted area formula from http://www.ipublishing.co.in/jarvol1no12010/EIJAER2011.pdf
plane.geo.wing.h_t = 0.301; %nondimensional distance to maximum thickness

plane.geo.wing.LE = (0.05*plane.geo.body.L) + rand()*(plane.geo.body.L*(0.45-0.05));
% need to define distance from nosetip to wing edge
plane.geo.wing.h_ac = 0.25; %nondimensional, distance from wing leading edge to AC
plane.geo.wing.ac = plane.geo.wing.h_ac*plane.geo.wing.c; %ft, distance from wing leading edge to AC, set to quarter chord

%% horizontal tail
%%%%%% We're using the same airfoil for the tail? %%%%%%%%%%%
plane.geo.h_tail.cl_a = 6.88; %Cl/rad for NACA 6412 airfoil
plane.geo.h_tail.cl_0 = 0.7626; %Cl for 0 AOA for NACA 6412 airfoil
plane.geo.h_tail.TR = 0.4;
St_Sw = 0.1 + rand()*(0.7 - 0.1);
plane.geo.h_tail.S = St_Sw*plane.geo.wing.S; %ft^2, h_tail area
plane.geo.h_tail.AR = 3 + rand()*(8 - 3); %h_tail aspect ratio
plane.geo.h_tail.b = (plane.geo.h_tail.S * plane.geo.h_tail.AR)^0.5; %ft, h_tail span length
plane.geo.h_tail.c = 2*plane.geo.h_tail.S / (plane.geo.h_tail.b*(1+plane.geo.h_tail.TR)); %ft, h_tail chord length
plane.geo.h_tail.ThR = 0.12;
plane.geo.h_tail.sweep = 0 + rand()*(10-0); %degrees, sweep length
plane.geo.h_tail.S_wet = plane.geo.h_tail.S*(1.977 + 0.52*plane.geo.h_tail.ThR); %ft^2, wetted area formula from http://www.ipublishing.co.in/jarvol1no12010/EIJAER2011.pdf
plane.geo.h_tail.h_t = 0.301; %nondimensional distance to maximum thickness

plane.geo.h_tail.LE = plane.geo.body.L - 1.01*plane.geo.h_tail.c; % max location has end of tail = end of body

plane.geo.h_tail.ac = (plane.geo.h_tail.LE - plane.geo.wing.LE) + 0.25*plane.geo.h_tail.c/plane.geo.wing.c; %ft, distance from wing leading edge to htail AC, set to quarter chord
plane.geo.h_tail.h_ac = plane.geo.h_tail.ac/plane.geo.wing.c; %nondimensional, distance from wing leading edge to htail AC


%% vertical tail
plane.geo.v_tail.ThR = 0.12;
plane.geo.v_tail.TR = 0.57;
plane.geo.v_tail.S = 100 + rand()*(500 - 100); %ft^2, v_tail area
plane.geo.v_tail.AR = 0.8 + rand()*(2.2 - 0.8); %v_tail aspect ratio
plane.geo.v_tail.b = (plane.geo.v_tail.S*plane.geo.v_tail.AR)^0.5; %ft, v_tail span length, root to tip
plane.geo.v_tail.c = 2*plane.geo.v_tail.S/(plane.geo.v_tail.b*(1+plane.geo.v_tail.TR)); %ft, v_tail chord length
% (c+c*tr)/2*b=S
plane.geo.v_tail.sweep = 15 + rand()*(30-15); %degrees, sweep length
plane.geo.v_tail.S_wet = plane.geo.v_tail.S*(1.977 + 0.52*plane.geo.v_tail.ThR); %ft^2, wetted area formula from http://www.ipublishing.co.in/jarvol1no12010/EIJAER2011.pdf
plane.geo.v_tail.h_t = 0.301; %nondimensional distance to maximum thickness

 % max location has end of tail = end of body
plane.geo.v_tail.LE = plane.geo.body.L - 1.02*plane.geo.v_tail.c;
plane.geo.v_tail.ac = (plane.geo.v_tail.LE - plane.geo.wing.LE) + 0.25*plane.geo.v_tail.c/plane.geo.wing.c; %ft, distance from wing leading edge to vtail AC, set to quarter chord
plane.geo.v_tail.h_ac = plane.geo.v_tail.ac/plane.geo.wing.c; %nondimensional, distance from wing leading edge to vtail AC
plane.geo.v_tail.cl_a = 0.1*180/3.1415; %Cl/rad for NACA 6412 airfoil

%% nacelle
plane.geo.nacelle.L = 6; % Length of each nacelle (engine)
plane.geo.nacelle.D = 1.585; % Diameter of nacelle (engine)
plane.geo.nacelle.S_wet = 3.4*plane.geo.nacelle.L*plane.geo.nacelle.D;
plane.prop.fuel_mass = 1600 + rand()*(3000-1600); %lb - guess based off of bessieMk3

end

% function [plane] = getRandomPlaneOld(plane)
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
% plane.geo.wing.b = 60 + rand(1)*(150 - 60); %ft, wingspan
% plane.geo.wing.AR = plane.geo.wing.b^2 / plane.geo.wing.S; %wing aspect ratio
% plane.geo.wing.c = 2*plane.geo.wing.S / (plane.geo.wing.b*(1+plane.geo.wing.TR)); %ft, wing chord length
% plane.geo.wing.ThR = 0.12; % thickness ratio
% plane.geo.wing.sweep = 0 + rand(1)*(5-0); %degrees, sweep length
% plane.geo.wing.S_wet = plane.geo.wing.S*(1.977 + 0.52*plane.geo.wing.ThR); %ft^2, wetted area formula from http://www.ipublishing.co.in/jarvol1no12010/EIJAER2011.pdf
% plane.geo.wing.h_t = 0.301; %nondimensional distance to maximum thickness
% 
% plane.geo.wing.LE = (0.1*plane.geo.body.L) + rand(1)*(plane.geo.body.L*(0.9-0.1));
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
% 
% 
% plane.prop.fuel_mass = 1125.9 + randn(1)*1125.9/30; %lb - guess based off of bessieMk3
% 
% end
% 
% 
% 




