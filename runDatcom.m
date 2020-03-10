function [] = runDatcom(plane)

writeDatcomInput(plane);
[~,~] = system('datcom.exe < DATINTXT.txt');
dat = datcomimport('datcom.out',true,0);
dat = dat{1};
%% Static stability derivatives /rad
plane.data.aerodcom.aoa = dat.cl;
plane.data.aerodcom.cd = dat.cd;
plane.data.aerodcom.cl = dat.cl;
plane.data.aerodcom.cm = dat.cm;
plane.data.aerodcom.cn = dat.cn;
plane.data.aerodcom.ca = dat.ca;
plane.data.aerodcom.cla = dat.cla;
plane.data.aerodcom.cma = dat.cma;
plane.data.aerodcom.cnb = dat.cnb;
plane.data.aerodcom.clb = dat.clb;

%% Dynamic Stability Derivatives /rad
% pitching
plane.data.aerodcom.clq = dat.clq;
plane.data.aerodcom.cmq = dat.cmq;
% acceleration
plane.data.aerodcom.clad = dat.clad;
plane.data.aerodcom.clq = dat.clq;
% rolling
plane.data.aerodcom.clp = dat.clp;
plane.data.aerodcom.cyp = dat.cyp;
plane.data.aerodcom.cnp = dat.cnp;
% yawing
plane.data.aerodcom.cnr = dat.cnr;
plane.data.aerodcom.clr = dat.clr;

% center of pressure
plane.data.aerodcom.xcp = dat.xcp;


end