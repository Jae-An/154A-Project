function [plane, datcomfailed] = runDatcom(plane)
try
writeFastDatcomInput(plane);
[~,~] = system('datcom.exe < DATINTXT.txt');
dat = datcomimport('datcom.out',false,0);
dat = dat{1};
%% Static stability derivatives /rad
plane.data.aero.aoa = dat.alpha;
plane.data.aero.cd = dat.cd(:,:,1,10);
plane.data.aero.cl = dat.cl(:,:,1,10);
plane.data.aero.cm = dat.cm(:,:,1,10);
plane.data.aero.cn = dat.cn(:,:,1,10);
plane.data.aero.ca = dat.ca(:,:,1,10);
plane.data.aero.cla = dat.cla(:,:,1,10);
plane.data.aero.cma = dat.cma(:,:,1,10);
plane.data.aero.cnb = dat.cnb(1,:,1,10);
plane.data.aero.clb = dat.clb(:,:,1,10);

% Get wing-body Cl (Cyb = Clwb/beta)
plane.data.aero.clwb = dat.cl(:,:,1,5);

%% Dynamic Stability Derivatives /rad
% pitching
plane.data.aero.clq = dat.clq(1,:,1,10);
plane.data.aero.cmq = dat.cmq(1,:,1,10);

% acceleration
plane.data.aero.clad = dat.clad(:,:,1,10);
plane.data.aero.clq = dat.clq(:,:,1,10);
plane.data.aero.cmad = dat.cmad(:,:,1,10);

% rolling
plane.data.aero.clp = dat.clp(:,:,1,10);
plane.data.aero.cyp = dat.cyp(:,:,1,10);
plane.data.aero.cnp = dat.cnp(:,:,1,10);
% yawing
plane.data.aero.cnr = dat.cnr(:,:,1,10);
plane.data.aero.clr = dat.clr(:,:,1,10);

% center of pressure
plane.data.aero.xcp = dat.xcp(:,:,1,10);
datcomfailed = false;
catch
    datcomfailed = true;
    warning('runDatcom failed somehow')
    return
end

end