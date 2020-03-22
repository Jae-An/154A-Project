function [plane] = getCG(plane)
%% Component locations
body = plane.geo.body;
wing = plane.geo.wing;
h_tail = plane.geo.h_tail;
v_tail = plane.geo.v_tail;
weight = plane.data.weight;

x = zeros(11,1);

%%%%%%%%%%%% FIX WING CG %%%%%%%%%%%%%%
h = 0.52 - 0.25; %Nondimensional distance from quarter chord to hollow airfoil (2D) CG
%Calculate CG wrt LE for each lifting surface, assumes hollow wing with
%uniform shell thickness
cg_wing = 0.25*wing.c + wing.b*tan(deg2rad(wing.sweep))/3 + ((2*wing.c*h/3 - wing.b*tan(deg2rad(wing.sweep))/6)/(wing.TR+1)) + 2*wing.c*h*wing.TR;
cg_htail = 0.25*h_tail.c + h_tail.b*tan(deg2rad(h_tail.sweep))/3 + ((2*h_tail.c*h/3 - h_tail.b*tan(deg2rad(h_tail.sweep))/6)/(h_tail.TR+1)) + 2*h_tail.c*h*h_tail.TR;
cg_vtail = 0.25*v_tail.c + v_tail.b*tan(deg2rad(v_tail.sweep))/3 + ((2*v_tail.c*h/3 - v_tail.b*tan(deg2rad(v_tail.sweep))/6)/(v_tail.TR+1)) + 2*v_tail.c*h*v_tail.TR;

x(1) = wing.LE + cg_wing;   %ft, wing lcg location
x(2) = body.L/2;              %fuselage cg location  
x(3) = h_tail.LE + cg_htail;   %tail cg location
x(4) = v_tail.LE + cg_vtail;   %tail cg location
x(5) = wing.LE + wing.c/2;   %landing gear cg location
x(6) = wing.LE + wing.c/2;          %engine cg location
x(7) = wing.LE + wing.c/2;   %fuel systems cg location
x(8) = wing.LE + wing.c/2;   %surface controls cg location
x(9) = 50;                   %avionics cg location
x(10) = wing.LE + wing.c/2;  %fuel cg location
%11th element is payload, at cg 2 location

%% Calculate wet and dry cg
cg = zeros(3,1); %wet, dry, wet (predrop) cg: this order is so that nothing gets messed up (3rd element added later)

% Must calculate payload (postdrop) cg first
weight.W(10) = weight.W(10) - weight.fuel_1;
cg(2) = sum(weight.W(1:10).*x(1:10))/(weight.dry-weight.fuel_1);
x(11) = cg(2); %payload cg location (before and after drop should be exact same)

% Then for stability/stall calcs we can find predrop cg
cg(3) = sum(weight.W(1:11).*x(1:11))/(weight.wet-weight.fuel_1); 

% Finally go back and calculate wet (takeoff) cg
weight.W(10) = weight.W(10) + weight.fuel_1;
cg(1) = sum(weight.W(1:11).*x(1:11))/weight.wet;


%% Return
plane.data.weight.CG = cg;
plane.data.weight.x = x;

%% Calculate Relevant Lengths
% Wing
plane.geo.wing.cg = plane.data.weight.CG - plane.geo.wing.LE; %ft, distance from wing leading edge to CG
plane.geo.wing.h_cg = plane.geo.wing.cg/plane.geo.wing.c; %nondimensional, distance from wing leading edge to CG

% Horizontal Tail
plane.geo.h_tail.cg = plane.geo.h_tail.LE - plane.data.weight.CG; %ft, distance from h_tail leading edge to CG
plane.geo.h_tail.h_cg = plane.geo.h_tail.cg/plane.geo.wing.c; %nondimensional, distance from h_tail leading edge to CG

% Vertical Tail
plane.geo.v_tail.cg = plane.data.weight.CG - plane.geo.v_tail.LE; %ft, distance from v_tail leading edge to CG
plane.geo.v_tail.h_cg = plane.geo.v_tail.cg/plane.geo.wing.c; %nondimensional, distance from v_tail leading edge to CG