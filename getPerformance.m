function plane = getPerformance(plane) %,RC,SC

W = plane.data.weight.wet - plane.data.weight.retardent;

%ROC = (Pav - Preq) / W
Pav = 2 * plane.prop.hp * 550;

S = plane.geo.wing.S;
CD = plane.data.aero.CD(50,2);
CL = plane.data.aero.CL(50,2);
rho = 0.00238;
Vcruise = 290;

%Preq = ( (2*(S^2)*(CD^2)*(W^3)) / (rho*(CL^3)) )^0.5;
Preq = CD * 0.5 * .00238 * (Vcruise^2) * S * Vcruise;

plane.data.performance.ROC = (Pav - Preq) / W;


% R = (npr / cp) * CL/CD * ln(Wi/Wf)

plane.data.performance.R = 2640000;
 

end

