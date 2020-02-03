function [Weight] = weight_function(plane)



Weight = 35000;  %lbs, initial weight guess
W_total = zeros(20,1);

for i = 1:20
W_total(i) = Weight;

%% wing geometry and weight
S = plane.geo.wing.S;                           %wing area, ft^2   % 
AR = plane.geo.wing.AR;                         %aspect ratio

N = plane.performance.N;                      %Ultimate Load Factor (1.5 times limit load factor)(GIVEN)
sweep_angle = plane.geo.wing.sweep;            %Deg %Wing 1/4 chord sweep angle
taper_ratio = plane.geo.wing.taper_ratio;     %Taper Ratio
thickness_ratio_wing = plane.geo.thickness_ratio;                  %Maximum Thickness Ratio (GIVEN)
v_max = plane.performance.v_max;                 %kts   %Equivalent Vmax at SL

W_wing = 96.948 * ((Weight * N/10^5)^0.65*(AR/cos(sweep_angle))^0.57*(S/100)^0.61*((1 + taper_ratio)/(2*thickness_ratio_wing))^0.36*(1+v_max/500)^0.5)^0.993;


%% Tail 

S_horizontal_tail = plane.geo.h_tail.S;   %horizontal tail area, ft^2
S_vertical_tail = plane.geo.v_tail.S;                  %vertical tail area, ft^2
b_horizontal_tail = plane.geo.h_tail.b;  %horizontal tail span, ft
b_vertical_tail = plane.geo.v_tail.b;  %vertical tail span in, ft


h_ac_wing = plane.geo.wing.h_ac;    %nondimensional distance from wing AC to CG
chord_wing = plane.geo.wing.c;       %chord length, ft
chord_horizontal_tail = plane.geo.h_tail.c;      %chord length, horizontal tail, ft
chord_vertical_tail = plane.geo.v_tail.c;       %chord length, vertical tail, ft
h_ac_horizontal =  plane.geo.h_tail.h_ac;    %nondimensional distance from AC to horizontal tail AC
h_ac_vertical = plane.geo.v_tail.h_ac;    %nondimensional distance from AC to vertical tail AC 


%% Horizontal Tail Weight

lh = 35 / 12 + (.5 - h_ac_wing) * chord_wing - (.5 - h_ac_horizontal) * chord_horizontal_tail; %ft       %Distance from Wing MAC to Tail MAC
thr = chord_horizontal_tail*.12*12; %ft      %horizontal tail max root thickness (chord * thick/chord)

W_horizontal_tail = 127*((Weight * N/10^5)^0.87*(S_horizontal_tail/100)^1.2*(lh/10)^0.483*(b_horizontal_tail/thr)^0.5)^0.458; %horizontal tail weight

%% Vertical Tail Weight

tvr = chord_vertical_tail*.12*12; %in    %Vertical Tail Max Root Thickness (chord * thick/chord * in/ft)

Weight_vertical_tail = (2)*  98.5*((Weight * N/10^5)^0.87*(  (.5)*  S_vertical_tail/100)^1.2*(  (.5)*  b_vertical_tail/tvr)^0.5)^0.458;

%% Fuselage Weight

length_fuselage = plane.geo.body.L;     %ft       %Fuselage Length
width_fuselage = plane.geo.body.W;      %ft        %Fuselage Width
depth_fuselage = plane.geo.body.D;  %ft          %Fuselage Max Depth

Weight_fuselage = 200*((Weight*N/10^5)^0.286*(length_fuselage/10)^0.857*((width_fuselage+depth_fuselage)/10)*(v_max/100)^0.338)^1.1;


%% Landing Gear Weight

Llg = 18; %in     %Length of Main Landing Gear Strut
N_land = 2;        %Ultimate Load Factor at Wland
Weight_landing_gear = 0.054*(Llg)^0.501*(Weight*N_land)^0.684;

%don't need niccolai if we have specific landing gear 
%Wlg = 100;      %lbs, weight landing gear

%% TOTAL STRUCTURAL WEIGHT

W_struct = W_wing + Weight_fuselage + W_horizontal_tail + Weight_vertical_tail + Weight_landing_gear;


%% Total Propulsion Unit (minus Fuel system) Weight

W_eng = plane.propulsion.engine_mass; %(lbs)     %Bare Engine Weight
N_eng = 2;             %# Engines

W_prop = 2.575*(W_eng)^0.922*N_eng;    %this equation likely over-estimates propulsion unit weight for a small UAV


%% Fuel Weight

W_fuel = plane.propulsion.fuel_mass;   %(lbs)  

%% Fuel System Weight

%rhof = 6.739; %lb/gal fuel mass density JP-8
%Fg = Wfu / rhof; %gal               %Total Fuel
%tankint=1; %percent         %Percent of Fuel Tanks that are integral
%Nt=2;                         %Number of Separate Fuel Tanks
%Wfs=2.49*((Fg)^0.6*(1/(1+tankint))^0.3*Nt^0.2*Neng^0.13)^1.21

% specific fuel system weights (fuel tanks, lines) likely can be found for your aircraft, if so, use those actual values instead of the niccolai equations.
Wfs = 100;  %lbs 

%% Surface Controls Weight

Wsc = 1.066*Weight^0.626;  

%% Avionics Weight - use weights of specific sensors you choose

W_avionics = 1;      


%% Payload Weight

W_payload = 16000;    %lbs, weight retardent

%% TOTAL WEIGHT

W_total(i) = W_struct + W_prop + Wfs + Wsc + W_payload + W_fuel + W_avionics;
Weight = W_total(i);

end
%figure; grid on;
hold on

plot(Wto,'.-m')

