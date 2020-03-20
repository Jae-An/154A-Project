function [planeGood, rocGood, VcGood, GeoIsGood] = isGood(plane)
%% identifying good RoC
if plane.data.performance.ROC >= 33
    rocGood = true;
else
    rocGood = false;
end


%% V_cruise good
if plane.data.aero.v_cruise(1) >= 220 && plane.data.aero.v_cruise(2) >= 220
    VcGood = true;
else
    VcGood = false;
end

%% Range
if plane.data.performance.R >= 500*5280%% && plane.data.performance.R <= 600*5280
    rangeGood = true;
else
    rangeGood = false;
end

%% Need to be able to fly at at least stall speed ADD ANGLE OF ATTACKS
if plane.prop.thrust(1) - plane.data.aero.D(1,1) >= 0
    minSpeedGood = true;
else
    minSpeedGood = false;
end

%% isStable
stabilityGood = false;
if plane.data.stability.is_stable && plane.data.stability.yaw_is_stable
    stabilityGood = true;
end

%% geometry good
geo = plane.geo;
GeoIsGood = false;
    AreaRatioGood = false;
    fitsRetardent = false;    
    fitsFuel = false;
    % check wing area ratios
    if geo.wing.S > geo.h_tail.S && geo.wing.S > geo.v_tail.S
        AreaRatioGood = true;
    end
    % fits retardent
    if (geo.body.L * 0.25*pi*geo.body.D^2 > 256 * 2) %fuselage volume at least 2x water volume
        fitsRetardent = true;
    end
    % fits fuel in wing
    wingVolume = 0.5*geo.wing.c*geo.wing.b*(geo.wing.TR+1) * 0.0815662901; % number from area of airfoil per chord length
    if plane.prop.fuel_volume < 0.5*wingVolume % Allow half volume margin for wing "fuel box"
        fitsFuel = true;
    end
% Overall geo check
if all([AreaRatioGood, fitsRetardent, fitsFuel])
    GeoIsGood = true;
end
    
%% Real
real = false;
if isreal(plane.data.aero.CD) && isreal(plane.data.aero.CL)
    real = true;
end

%% Overall Good
planeGood = false;

if GeoIsGood && rocGood && VcGood && rangeGood && stabilityGood && plane.data.aero.isreal && minSpeedGood
    planeGood = true;
end


end


