function plane = plane()
%Creates an instance of the plane class

plane = struct('geo',[],'prop',[],'data',[]);

%% Aircraft Geometry
plane.geo = struct('body',[],'wing',[],'h_tail',[],'v_tail',[],'nacelle',[]);
    plane.geo.body = struct('L',[],'W',[],'D',[]);
    plane.geo.wing = struct('S',[],'AR',[],'c',[],'b',[],'thickness',[],'taper',[],'sweep',[],'cg',[],'ac',[],'h_cg',[],'h_ac',[],'alpha',[]);
    plane.geo.h_tail = struct('S',[],'AR',[],'c',[],'b',[],'thickness',[],'taper',[],'sweep',[],'cg',[],'ac',[],'h_cg',[],'h_ac',[],'alpha',[]);
    plane.geo.v_tail = struct('S',[],'AR',[],'c',[],'b',[],'thickness',[],'taper',[],'sweep',[],'cg',[],'ac',[],'h_cg',[],'h_ac',[],'alpha',[]);
    plane.geo.nacelle = struct(); % *fill out later*

%% Propulsion
plane.prop = struct('W',[],'hp',[],'eta_p',[],'c_p',[],'fuel_mass',[]);


%% Performance, Aerodynamics, Stability
plane.data = struct('W',[],'CL',[],'CD',[],'CD0',[],'CDi',[],'CL_alpha',[],'h_n',[],'N',5,'v_max',217.244,'v_stall',86.8976); % *fill out later*