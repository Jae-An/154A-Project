function plane = plane()
%Creates an instance of the plane class

plane = struct('geo',[],'prop',[],'data',[]);

%% Aircraft Geometry
plane.geo = struct('body',[],'wing',[],'h_tail',[],'v_tail',[],'nacelle',[]);
    plane.geo.body = struct('L',[],'W',[],'D',[]);
    plane.geo.wing = struct('S',[],'AR',[],'c',[],'b',[],'ThR',[],'TR',[],'sweep',[],'cg',[],'ac',[],'h_cg',[],'h_ac',[],'alpha',[]);
    plane.geo.h_tail = struct('S',[],'AR',[],'c',[],'b',[],'ThR',[],'TR',[],'sweep',[],'cg',[],'ac',[],'h_cg',[],'h_ac',[],'alpha',[]);
    plane.geo.v_tail = struct('S',[],'AR',[],'c',[],'b',[],'ThR',[],'TR',[],'sweep',[],'cg',[],'ac',[],'h_cg',[],'h_ac',[],'alpha',[]);
    plane.geo.nacelle = struct(); % *fill out later*

%% Propulsion
plane.prop = struct('W',[],'hp',[],'eta_p',[],'c_p',[],'fuel_mass',[]);


%% Performance, Aerodynamics, Stability
plane.data = struct('requirements',[],'performance',[],'aero',[],'stability',[]);
    plane.data.requirements = struct('R',500,'v_max',217.244,'v_stall',86.8976);
    plane.data.weight = struct('W',[],'dry',[],'wet',[],'fuel',[],'retardent',[]);
    plane.data.performance = struct('R',[],'E',[],'ROC',[],'v_max',217.244,'v_stall',86.8976,'N',5);
    plane.data.aero = struct('CL_wet',[],'CL_dry',[],'CL_alpha',[],'CD_wet',[],'CD_dry',[],'CD0',[],'CDi',[]);
    plane.data.stability = struct('h_n',[]);