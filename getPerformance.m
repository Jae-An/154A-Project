function plane = getPerformance(plane) %,RC,SC

Dry_weight = plane.data.weight.wet - plane.data.weight.retardent;

%% ROC = (Pav - Preq) / W
Pav = 2 * plane.prop.hp * 550;

S = plane.geo.wing.S;
AR = plane.geo.wing.AR;
e = 0.35; % approx oswald efficiency for an eliptical wing
CD0_min = min(plane.data.aero.CD0);
CL_maxRC = (3*CD0_min*3.1415*AR*e)^0.5;
CD_max_RC = CD0_min + (CL_maxRC^2)/(3.1415*AR*e);
rho = 0.00238;
V_ref = (Dry_weight/(0.5*rho*CL_maxRC*S))^0.5;

%Preq = ( (2*(S^2)*(CD^2)*(W^3)) / (rho*(CL^3)) )^0.5;
Preq = 0.5 * CD_max_RC * rho * (V_ref^2) * S * V_ref;

plane.data.performance.ROC = (Pav - Preq) / Dry_weight;

%% range
prop = plane.prop;
weight = plane.data.weight;
LD = plane.data.aero.LD;
weightInitial1 = weight.wet;
weightFinal1 = weightInitial1 - weight.fuel_1;
weightInitial2 = weightFinal1 - weight.retardent;
weightFinal2 = weight.empty;

eta_p = max(prop.eta_p); %assuming flying at cruise speed with maximum propellar efficiency
R1 = (eta_p / prop.c_p) * LD(1) * log(weightInitial1/weightFinal1);
R2 = (eta_p / prop.c_p) * LD(1) * log(weightInitial2/weightFinal2);

plane.data.performance.R = R1 + R2;
 

end