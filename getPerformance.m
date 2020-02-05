function [Range,RC] = getPerformance(plane) %,RC,SC,v_max,v_min

prop = plane.prop;
weight = plane.data.weight;
V_cruise = 200*1.466; %ft/s

Drag_cruise = plane.data.Cd * 0.5 * 0.00238 * (V_cruise^2) * plane.geo.wing.S;


Range = (prop.eta_p/prop.c_p)*(plane.data.CL/plane.data.CD)*log(weight.weight_wet/weight.weight_dry)
 
RC = ((prop.hp*550) - (V_cruise*Drag_cruise)) / weight


end

