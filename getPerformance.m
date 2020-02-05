function [Range,Endurance,RC,SC,N,v_max,v_min] = getPerformance(plane)

prop = plane.prop;
weight = plane.data.weight;

Range = (prop.eta_p/prop.c_p)*(CL/CD)*log(weight.weight_wet/weight.weight_dry);
Endurance = %compute this 
RC = ((prop.hp*550) - 
end

