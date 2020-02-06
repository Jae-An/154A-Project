function plane = plane()
%Creates an instance of the plane class

plane = struct('geo',[],'prop',[],'data',[]);

%% Aircraft Geometry
plane.geo = struct('body',[],'wing',[],'h_tail',[],'v_tail',[],'nacelle',[]);
    plane.geo.body = struct('L',[],'W',[],'D',[]);
    plane.geo.wing = struct('S',[],'AR',[],'c',[],'b',[],'ThR',[],'TR',[],'sweep',[],'cg',[],'ac',[],'h_cg',[],'h_ac',[],'cl_a',[],'cl_0',[]);
    plane.geo.h_tail = struct('S',[],'AR',[],'c',[],'b',[],'ThR',[],'TR',[],'sweep',[],'cg',[],'ac',[],'h_cg',[],'h_ac',[],'h_t',[],'cl_a',[],'cl_0',[],'i',[]);
    plane.geo.v_tail = struct('S',[],'AR',[],'c',[],'b',[],'ThR',[],'TR',[],'sweep',[],'cg',[],'ac',[],'h_cg',[],'h_ac',[],'cl_a',[]);
    plane.geo.nacelle = struct(); % *fill out later*

%% Propulsion
plane.prop = struct('W',[],'hp',[],'eta_p',[],'c_p',[],'fuel_mass',[]);


%% Performance, Aerodynamics, Stability
plane.data = struct('requirements',[],'performance',[],'aero',[],'stability',[]);
    plane.data.requirements = struct('R',500,'v_max',367,'v_stall',146);
    plane.data.weight = struct('W',[],'dry',[],'wet',[],'empty',[],'fuel',[],'retardent',[]);
    plane.data.performance = struct('R',[],'E',[],'ROC',[],'v_max',217.244,'v_stall',86.8976,'N',5);
    plane.data.aero = struct('CL',[],'CL_alpha',[],'CD',[],'CD0',[],'CDi',[]);
    plane.data.stability = struct('h_n',[]);

