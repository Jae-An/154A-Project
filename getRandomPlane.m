function [plane] = getRandomPlane()

%randomization format
%rand_value = min_value + rand(1)*(max_value - min_value)

%fuselage
plane.geo.body.L = 20 + rand(1)*(80 - 20); %ft, fuselage length
plane.geo.body.W = 5 + rand(1)*(20 - 5); %ft, fuselage width
plane.geo.body.D = 1 + rand(1)*(20 - 1); %ft, fuselage depth

%wing
plane.geo.wing.S = 20 + rand(1)*(2000 - 20); %ft^2, wing area
plane.geo.wing.AR = 1 + rand(1)*(20 - 1); %wing aspect ratio
plane.geo.wing.c = 3 + rand(1)*(12 - 3); %ft, wing chord length
plane.geo.wing.b = (plane.geo.wing.AR * plane.geo.wing.S)^0.5; 








