function plane = plane()
%Creates an instance of the plane class

plane = struct('geo',[],'prop',[],'data',[]);

%% Aircraft Geometry
plane.geo = struct('body',[],'wing',[],'h_tail',[],'v_tail',[],'nacelle',[]);
    plane.geo.body = struct('L',[],'W',[],'D',[]);
    plane.geo.wing = struct('S',[],'S_wet',[],'AR',[],'c',[],'b',[],'ThR',[],'TR',[],'sweep',[],'cg',[],'ac',[],'h_cg',[],'h_ac',[],'h_t',[],'cl_a',[],'cl_0',[],'cm_ac',[],'a_stall',[]);
    plane.geo.h_tail = struct('S',[],'S_wet',[],'AR',[],'c',[],'b',[],'ThR',[],'TR',[],'sweep',[],'cg',[],'ac',[],'h_cg',[],'h_ac',[],'h_t',[],'cl_a',[],'cl_0',[],'i',[],'e_a',[],'a_stall',[]);
    plane.geo.v_tail = struct('S',[],'S_wet',[],'AR',[],'c',[],'b',[],'ThR',[],'TR',[],'sweep',[],'cg',[],'ac',[],'h_cg',[],'h_ac',[],'h_t',[],'cl_a',[]);
    plane.geo.nacelle = struct(); % *fill out later*

%% Propulsion
plane.prop = struct('W',[],'hp',[],'eta_p',[],'c_p',[],'fuel_mass',[]);


%% Performance, Aerodynamics, Stability
plane.data = struct('requirements',[],'performance',[],'aero',[],'stability',[]);
    plane.data.requirements = struct('R',500,'v_max',367,'v_stall',146);
    plane.data.weight = struct('W',[],'dry',[],'wet',[],'empty',[],'fuel',[],'retardent',[]);
    plane.data.performance = struct('R',[],'E',[],'ROC',[],'v_max',366.667,'v_stall',146.667,'N',5);
    plane.data.aero = struct('CL',[],'CL_a',[],'CD',[],'CD0',[],'CDi',[]);
    plane.data.stability = struct('h_n',[]);
    plane.data.test = struct('is_stable',[],'no_stall',[]);

