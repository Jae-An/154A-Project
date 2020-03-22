function [plane] = getPropulsionDetails(plane)

% we could have a bunch of different engines and have this function pick
% one of them at random

%% GE catalyst Turboprop engine
plane.prop.numengines = 2;
plane.prop.W = 600; %lb % Niccolai equations take numengines into account later!!!
plane.prop.hp = plane.prop.numengines*1300; %hp
%plane.prop.eta_p = 0.65; % This needs to be updated as a function of velocity or a look up table of some sort
plane.prop.c_p = 0.5; % lb / hp-h
plane.prop.c_p = plane.prop.c_p /(550*60*60); % (ft^-1) Fixes units for range calculation
plane.prop.fuel_mass = 1125.9 + randn(1)*1125.9/30; %lb - guess based off of bessieMk3
plane.prop.fuel_volume = plane.prop.fuel_mass/48.381874; % (ft^3) - density from jet fuel, which has 775 g/L minimum density for max volume

%% Propeller calcs

%airspeed
v_stall = plane.data.requirements.v_stall; %v_ref set to stall velocity, ft/s
v_max = plane.data.requirements.v_max;
V = linspace(v_stall, v_max);

%propeller speed
plane.prop.n = 1200/60; % [rotation/sec]

%propeller diameter
plane.prop.D = 12; %[ft]

%advance ratio
J = V ./ (plane.prop.n*plane.prop.D);

%efficiency - look up table 30 deg (NACA report 640 figure 5)
% - used WebPlotDigitizer

% 30 degrees
%J_table = [0.30158168713294176, 0.40226908702616115, 0.35191537640149484, 0.4463160704751734, 0.49975306994127067, 0.5532501334757074, 0.600340363053924, 0.6474706353443673, 0.700867592098238, 0.7448945541911371, 0.8015149492792312, 0.8487653497063534,0.8992191671115858,0.9560197544046983, 1.0002068873465026, 1.0507407901761878,1.101274693005873, 1.199259209823812, 1.2530165509877202, 1.2973438334223168, 1.354404698344901, 1.4020955686065135, 1.4404364655632673, 1.4596970101441538,1.485624666310731, 1.5020822210357714, 1.511992792311799, 1.5186799252536036, 1.5253470368392952, 1.528850774159103, 1.53247463961559, 1.5391417512012813, 1.5394220501868658, 1.5429057661505607, 1.5432461292044848, 1.472670848905499,1.4922717565403096];
%eta_table = [0.2472492881295606,0.3330463605623778,0.2917300676276918,0.3711759209823813,0.4251612831464674,0.4696531856202172,0.526780788396512,0.5775794180459157,0.6378937533368928,0.6791878003203419,0.730019798896601,0.761831509165332,0.7873253692827906,0.8096769887880406,0.8256551432639261,0.8384910571276029,0.8513269709912796,0.864329729489233,0.8676833066381919,0.8615100551699592,0.8427233493504183,0.8049163552233494,0.7449245862253071,0.7006885121907813,0.6026784125289197,0.5014704573767576,0.4350496084712584,0.378111096280477,0.3243370706531412,0.27055192205018697,0.19777985406656007,0.14400582843922416,0.0997030165509879,0.04908235451147891,-0.004713917067093787,0.6501012190781279,0.5520688734650294];

%plane.prop.eta_p = interp1(J_table, eta_table, J); %this works, need to integrate it into rest of script - will affect anything with thrust


%

% 35 degrees

J_table = [0.4037974683544303,0.460759493670886,0.5018987341772151,0.5462025316455695, 0.6, 0.6537974683544303, 0.7075949367088608, 0.7582278481012659, 0.7993670886075949,0.8563291139240505,0.9037974683544304, 0.9481012658227849,1.0018987341772152, 1.0556962025316454, 1.1063291139240508,1.1569620253164556,1.2044303797468356, 1.2550632911392405, 1.30253164556962, 1.359493670886076, 1.4069620253164556, 1.4607594936708859, 1.5082278481012659, 1.562025316455696,1.6063291139240508,1.6537974683544303, 1.688607594936709, 1.7170886075949365, 1.7360759493670885, 1.7518987341772152, 1.7645569620253165, 1.7772151898734179,1.7867088607594939,1.7993670886075952, 1.8056962025316459,1.8151898734177219, 1.821518987341772,1.8278481012658228,1.831012658227848];

eta_table = [0.27703864090606267, 0.3151132578281146, 0.3436642238507662, 0.37222518321119247, 0.4134477015323118, 0.451512325116589, 0.48641905396402396, 0.5244736842105263, 0.55618254497002, 0.6068887408394403, 0.64809127248501, 0.6892838107928048, 0.7241905396402398, 0.7590972684876749, 0.7845203197868088, 0.8067854763491007, 0.8195669553630913, 0.8323584277148568, 0.8419820119920053, 0.8484776815456363, 0.8517854763491006, 0.8551132578281146, 0.8521052631578947, 0.8364856762158561, 0.820836109260493, 0.78309127248501, 0.7421485676215855, 0.6980279813457695, 0.6570353097934709, 0.6097168554297134, 0.5623884077281812, 0.5087441705529646, 0.4487741505662892, 0.36986675549633574, 0.2909393737508327, 0.23728514323784133, 0.15835776149233838, 0.07627248500999328, 0.009966688874083918];

plane.prop.eta_p = interp1(J_table, eta_table, J); %this works, need to integrate it into rest of script - will affect anything with thrust

%figure;
%plot(J, eta)


end
