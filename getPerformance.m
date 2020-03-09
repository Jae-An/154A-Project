function plane = getPerformance(plane) %,RC,SC

Dry_weight = plane.data.weight.wet - plane.data.weight.retardent;

%% ROC = (Pav - Preq) / W
Pav = plane.prop.hp * 550;

S = plane.geo.wing.S;
AR = plane.geo.wing.AR;
e = 0.85; % approx oswald efficiency for an eliptical wing

CD0_climb = plane.data.aero.CD0(1,2);
CL_climb = (3*CD0_climb*pi*AR*e)^0.5;
CD_climb = CD0_climb + (CL_climb^2)/(pi*AR*e);
rho = 0.00238; % Sea level climb rates
V_ref = (Dry_weight/(0.5*rho*CL_climb*S))^0.5;

%Preq = ( (2*(S^2)*(CD^2)*(W^3)) / (rho*(CL^3)) )^0.5;
Preq = 0.5 * CD_climb * rho * (V_ref^2) * S * V_ref;

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
R2 = (eta_p / prop.c_p) * LD(2) * log(weightInitial2/weightFinal2);

plane.data.performance.R = R1 + R2;
 

end