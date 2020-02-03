function [plane] = getRandomPlane()

%randomization format
%rand_value = min_value + rand(1)*(max_value - min_value)

%fuselage
plane.geo.body.L = 20 + rand(1)*(80 - 20); %ft, fuselage length
plane.geo.body.W = 5 + rand(1)*(20 - 5); %ft, fuselage width
plane.geo.body.D = 1 + rand(1)*(20 - 1); %ft, fuselage depth

%wing
plane.geo.wing.S = 20 + rand(1)*(2000 - 20); %ft^2, wing area




