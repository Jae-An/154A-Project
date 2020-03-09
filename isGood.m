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
if plane.data.performance.R >= 500*5280
    rangeGood = true;
else
    rangeGood = false;
end

%% Need to be able to fly at at least stall speed
if plane.prop.thrust(1) - plane.data.aero.D(1,1) >= 0
    minSpeedGood = true;
else
    minSpeedGood = false;
end

%% isStable



%geometry good
wing = plane.geo.wing;
h_tail = plane.geo.h_tail;
body = plane.geo.body;
GeoIsGood = false;


if wing.S > h_tail.S %checking if wing area is greater than tail area
    GeoIsGood = true;
end

%fits retardent
if (body.L * body.W * body.D > 256 * 4) %fuselage volume at least 4x water volume
    fitsRetardent = true;
end



%% Real
real = false;
if isreal(plane.data.aero.CD) && isreal(plane.data.aero.CL)
    real = true;
end

%% Overall Good
planeGood = false;

if GeoIsGood && rocGood && VcGood && rangeGood && plane.data.stability.is_stable && plane.data.aero.isreal && fitsRetardent && minSpeedGood
    planeGood = true;
end


end


