function [Range,Endurance,RC,SC,N,v_max,v_min] = getPerformance(plane)

prop = plane.prop;
weight = plane.data.weight;
V_cruise = 200*1.466; %ft/s

Drag_cruise = 

Range = (prop.eta_p/prop.c_p)*(CL/CD)*log(weight.weight_wet/weight.weight_dry);
 
RC = ((prop.hp*550) - (V_cruise*Drag_cruise)) / weight;
end

