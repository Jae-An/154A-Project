function [I] = getInertias(plane)

% x(1)  %ft, wing lcg location
% x(2)              %fuselage cg location  
% x(3)    %tail cg location
% x(4)    %tail cg location
% x(5)    %landing gear cg location
% x(6)    %engine cg location
% x(7)    %fuel systems cg location
% x(8)    %surface controls cg location
% x(9)     %avionics cg location
% x(10)   %fuel cg location
% %11th element is payload, at cg location

wing = plane.geo.wing;
body = plane.geo.body;
h_tail = plane.geo.h_tail;
v_tail = plane.geo.v_tail;
x = plane.data.weight.x;
cg = plane.data.weight.CG;
W = plane.data.weight.W;
x = x-cg(2);
%contributions from wing, horizontal and vertical tail, retardent tank,
%fuel tank fuselage, engines

%% Ixx
%Ixx_wing = (1/12)*(W(1)*wing.b^2) + 0.25*(W(1)*wing.c^2);
Ixx_wing = (1/12)*(W(1)*(wing.b/2)^2);
Ixx_tail = (1/12)*(x(3)^2)*(W(3)+W(4));
Ixx_fuel = (1/12)*(W(10)*wing.b^2) + W(10)*x(10)^2;
Ixx_engines = (plane.prop.W*(wing.b/4)^2);
Ixx_fuselage = (1/2)*(W(2)*(x(2)^2));
Ixx_retardent = (2/5)*W(11)*body.W^2;

Ixx_dry = Ixx_wing + Ixx_tail  + Ixx_fuel + Ixx_engines + Ixx_fuselage;
Ixx_wet = Ixx_dry + Ixx_retardent;

%% Iyy
Iyy_wing = (1/2)*(W(1)*wing.c^2) + W(1)*(x(1)^2) ;
Iyy_tail = (1/2)*(x(3)^2)*(W(3)+W(4)) + 0.25*((W(3)+W(4)))*(v_tail.b^2) + (W(3)+W(4))*(x(3)^2);
Iyy_fuel = (1/12)*(W(10)*wing.b^2)+W(10)*(x(1)^2) ;
Iyy_engines = (plane.prop.W*(wing.b/2)^2) +W(6)*(x(1)^2) ;
Iyy_fuselage = (1/12)*(W(2)*body.L^2);
Iyy_retardent = (2/5)*W(11)*body.W^2;

Iyy_dry = Iyy_wing + Iyy_tail  + Iyy_fuel + Iyy_engines + Iyy_fuselage;
Iyy_wet = Iyy_dry + Iyy_retardent;


%% Izz
Izz_wing = (1/12)*(W(1)*wing.b^2) + W(1)*(x(1)^2);
Izz_tail = (1/2)*(x(3)^2)*(W(3)+W(4)) + (W(3)+W(4))*(x(3)^2);
Izz_fuel = (1/12)*(W(10)*wing.b^2)+W(10)*(x(1)^2) ;
Izz_engines = (plane.prop.W*(wing.b/3)^2) +W(6)*(x(1)^2) ;
Izz_fuselage =  + (1/12)*(W(2)*body.L^2);
Izz_retardent = (2/5)*W(11)*body.W^2;

Izz_dry = Izz_wing + Izz_tail  + Izz_fuel + Izz_engines + Izz_fuselage;
Izz_wet = Izz_dry + Izz_retardent;

%% store I's
I = zeros(2,3);
I(1,1) = Ixx_dry; I(2,1) = Ixx_wet;
I(1,2) = Iyy_dry; I(2,2) = Iyy_wet;
I(1,3) = Izz_dry; I(2,3) = Izz_wet;
I = I/32.2;

%% Ixz


end

