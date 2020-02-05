function [plane] = getPropulsionDetails(plane)

% we could have a bunch of different engines and have this function pick
% one of them at random

% GE catalyst Turboprop engine
plane.prop.W = 600; %lb
plane.prop.hp = 1300; %hp
plane.prop.eta_p = 0.65; % This needs to be updated as a function of velocity or a look up table of some sort
plane.prop.c_p = 0.5; % lb / hp-h
plane.prop.fuel_mass = 5000; %lb - guess based off of sfc*1300hp*5hrs

end

