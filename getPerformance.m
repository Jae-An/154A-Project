function plane = getPerformance(plane) %,RC,SC,v_max,v_min

prop = plane.prop;
weight = plane.data.weight;
V_cruise = 200*1.466; %ft/s

%Drag_cruise = plane.data.aero.CD(50,2) * 0.5 * 0.00238 * (V_cruise^2) * plane.geo.wing.S;
Drag_cruise = 0.3 * 0.5 * 0.00238 * (V_cruise^2) * plane.geo.wing.S;

plane.data.performance.R = (prop.eta_p/(prop.c_p / (550*60*60) ))*(plane.data.aero.CL(50,2)/plane.data.aero.CD(50,2))*log(weight.wet/weight.dry);
 
plane.data.performance.ROC = ((prop.hp*550) - (V_cruise*Drag_cruise)) / weight.W;


end

