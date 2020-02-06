function plane = getPerformance(plane) %,RC,SC

W = plane.data.weight.wet - plane.data.weight.retardent;

%ROC = (Pav - Preq) / W
Pav = 2 * plane.prop.hp * 550;

S = plane.geo.wing.S;
CD = plane.data.aero.CD(50,1);
CL = plane.data.aero.CL(50,1);
rho = 0.00238;

Preq = ( (2*(S^2)*(CD^2)*(W^3)) / (rho*(CL^3)) )^0.5;

plane.data.performance.ROC = (Pav - Preq) / W;


% R = (npr / cp) * CL/CD * ln(Wi/Wf)

npr = plane.prop.eta_p;
cp = plane.prop.c_p / (550 * 60 *60);
Wi = plane.data.weight.wet;
Wf = plane.data.weight.dry;

plane.data.performance.R = (npr / cp) * (CL/CD) * log(Wi/Wf);
 

end

