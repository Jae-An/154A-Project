function [plane] = getCG(plane)
%% Component locations
body = plane.geo.body;
wing = plane.geo.wing;
h_tail = plane.geo.h_tail;
weight = plane.data.weight;

x = zeros(11,1);

%%%%%%%%%%%% FIX WING CG %%%%%%%%%%%%%%
x(1) = wing.LE + wing.c*0.52;   %ft, wing lcg location
x(2) = body.L/2;              %fuselage cg location  
x(3) = h_tail.LE + h_tail.c*0.52;   %tail cg location
x(4) = v_tail.LE + v_tail.c*0.52;   %tail cg location
x(5) = wing.LE + wing.c/2;   %landing gear cg location
x(6) = wing.LE + wing.c/2;          %engine cg location
x(7) = wing.LE + wing.c/2;   %fuel systems cg location
x(8) = wing.LE + wing.c/2;   %surface controls cg location
x(9) = 50;                   %avionics cg location
x(10) = wing.LE + wing.c/2;  %fuel cg location
%11th element is payload, at cg location

%% Calculate wet and dry cg
cg = zeros(2,1); %wet and dry cg
cg(1) = weight.W(1:10).*x(1:10)/weight.wet;
weight.W(10) = weight.W(10) - weight.fuel_1;
cg(2) = weight.W(1:10).*x(1:10)/(weight.dry-weight.fuel_1);

x(11) = cg(2); %payload cg location (before and after drop should be exact same)

%% Return
plane.data.weight.CG = cg;
plane.data.weight.x = x;

%% Calculate Relevant Lengths
% Wing
plane.geo.wing.cg = plane.data.weight.CG - plane.geo.wing.LE; %ft, distance from wing leading edge to CG
plane.geo.wing.h_cg = plane.geo.wing.cg/plane.geo.wing.c; %nondimensional, distance from wing leading edge to CG

% Horizontal Tail
plane.geo.h_tail.cg = plane.data.weight.CG - plane.geo.h_tail.LE; %ft, distance from h_tail leading edge to CG
plane.geo.h_tail.h_cg = plane.geo.h_tail.cg/plane.geo.wing.c; %nondimensional, distance from h_tail leading edge to CG

% Vertical Tail
plane.geo.v_tail.cg = plane.data.weight.CG - plane.geo.v_tail.LE; %ft, distance from v_tail leading edge to CG
plane.geo.v_tail.h_cg = plane.geo.h_tail.h_cg; %nondimensional, distance from v_tail leading edge to CG