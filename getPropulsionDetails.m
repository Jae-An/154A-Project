function [plane] = getPropulsionDetails(plane)

% we could have a bunch of different engines and have this function pick
% one of them at random

%% GE catalyst Turboprop engine
plane.prop.W = 600; %lb
plane.prop.hp = 1600; %hp
plane.prop.eta_p = 0.65; % This needs to be updated as a function of velocity or a look up table of some sort
plane.prop.c_p = 0.5; % lb / hp-h
plane.prop.fuel_mass = 5000; %lb - guess based off of sfc*1300hp*5hrs

%% Propeller calcs

%airspeed
v_stall = plane.data.requirements.v_stall; %v_ref set to stall velocity, ft/s
v_max = plane.data.requirements.v_max;
V = linspace(v_stall, v_max);

%propellar speed
n = 1200/60; % [rotation/sec]

%propellar diameter
D = 12; %[ft]

%advance ratio
J = V ./ (n*D);

%efficiency - look up table 30 deg (NACA report 640 figure 5)
% - used WebPlotDigitizer
J_table = [0.30158168713294176, 0.40226908702616115, 0.35191537640149484, 0.4463160704751734, 0.49975306994127067, 0.5532501334757074, 0.600340363053924, 0.6474706353443673, 0.700867592098238, 0.7448945541911371, 0.8015149492792312, 0.8487653497063534,0.8992191671115858,0.9560197544046983, 1.0002068873465026, 1.0507407901761878,1.101274693005873, 1.199259209823812, 1.2530165509877202, 1.2973438334223168, 1.354404698344901, 1.4020955686065135, 1.4404364655632673, 1.4596970101441538,1.485624666310731, 1.5020822210357714, 1.511992792311799, 1.5186799252536036, 1.5253470368392952, 1.528850774159103, 1.53247463961559, 1.5391417512012813, 1.5394220501868658, 1.5429057661505607, 1.5432461292044848, 1.472670848905499,1.4922717565403096];
eta_table = [0.2472492881295606,0.3330463605623778,0.2917300676276918,0.3711759209823813,0.4251612831464674,0.4696531856202172,0.526780788396512,0.5775794180459157,0.6378937533368928,0.6791878003203419,0.730019798896601,0.761831509165332,0.7873253692827906,0.8096769887880406,0.8256551432639261,0.8384910571276029,0.8513269709912796,0.864329729489233,0.8676833066381919,0.8615100551699592,0.8427233493504183,0.8049163552233494,0.7449245862253071,0.7006885121907813,0.6026784125289197,0.5014704573767576,0.4350496084712584,0.378111096280477,0.3243370706531412,0.27055192205018697,0.19777985406656007,0.14400582843922416,0.0997030165509879,0.04908235451147891,-0.004713917067093787,0.6501012190781279,0.5520688734650294];

eta = interp1(J_table,eta_table, J); %this works, need to integrate it into rest of script - will affect anything with thrust

%figure;
%plot(J, eta)


end

