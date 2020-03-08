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

%% isStable



%geometry good
wing = plane.geo.wing;
h_tail = plane.geo.h_tail;
body = plane.geo.body;
GeoIsGood = false;


if wing.S > h_tail.S %checking if wing area is greater than tail area
    GeoIsGood = true;
end

%% Overall Good
planeGood = false;
if GeoIsGood && rocGood && VcGood && plane.data.stability.is_stable && plane.data.aero.isreal
    planeGood = true;
end


end


