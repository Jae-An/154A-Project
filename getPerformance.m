function plane = getPerformance(plane) %,RC,SC

Dry_weight = plane.data.weight.wet - plane.data.weight.retardent;

%% ROC = (Pav - Preq) / W
Pe = plane.prop.hp * 550;
eta_p = plane.prop.eta_p(1);
Pav = Pe*eta_p;

S = plane.geo.wing.S;
CD_climb = plane.data.aero.CD(1,2);
rho = 0.00238; % Sea level climb rates
v_stall = plane.data.requirements.v_stall;

%Preq = ( (2*(S^2)*(CD^2)*(W^3)) / (rho*(CL^3)) )^0.5;
Preq = 0.5 * CD_climb * rho * (v_stall^2) * S * v_stall;

plane.data.performance.ROC = (Pav - Preq) / Dry_weight;

%% range
prop = plane.prop;
weight = plane.data.weight;
LD = plane.data.aero.LD;
weightInitial1 = weight.wet;
weightFinal1 = weightInitial1 - weight.fuel_1;
weightInitial2 = weightFinal1 - weight.retardent;
weightFinal2 = weight.empty;

v_max = plane.data.requirements.v_max;
v_ref = linspace(v_stall, v_max);
eta_p = interp1(v_ref,prop.eta_p,plane.data.aero.v_cruise); %assuming flying at cruise speed

R1 = (eta_p(1) / prop.c_p) * LD(1) * log(weightInitial1/weightFinal1);
R2 = (eta_p(2) / prop.c_p) * LD(2) * log(weightInitial2/weightFinal2);

plane.data.performance.R = R1 + R2;
 

end