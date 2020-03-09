function plane = plane()
%Creates an instance of the plane class

plane = struct('geo',[],'prop',[],'data',[]);

%% Aircraft Geometry
plane.geo = struct('body',[],'wing',[],'h_tail',[],'v_tail',[],'nacelle',[]);
    plane.geo.body = struct('L',[],'W',[],'D',[]);
    plane.geo.wing = struct('S',[],'S_wet',[],'AR',[],'c',[],'b',[],'ThR',[],'TR',[],'sweep',[],'cg',[],'ac',[],'h_cg',[],'h_ac',[],'h_t',[],'cl_a',[],'cl_0',[]);
    plane.geo.h_tail = struct('S',[],'S_wet',[],'AR',[],'c',[],'b',[],'ThR',[],'TR',[],'sweep',[],'cg',[],'ac',[],'h_cg',[],'h_ac',[],'h_t',[],'cl_a',[],'cl_0',[],'i',[]);
    plane.geo.v_tail = struct('S',[],'S_wet',[],'AR',[],'c',[],'b',[],'ThR',[],'TR',[],'sweep',[],'cg',[],'ac',[],'h_cg',[],'h_ac',[],'h_t',[],'cl_a',[]);
    plane.geo.nacelle = struct(); % *fill out later*

%% Propulsion
plane.prop = struct('W',[],'hp',[],'eta_p',[],'c_p',[],'fuel_mass',[]);


%% Performance, Aerodynamics, Stability
plane.data = struct('requirements',[],'performance',[],'aero',[],'stability',[]);
    plane.data.requirements = struct('R',500,'v_max',500,'v_stall',146);
    plane.data.weight = struct('CG',[],'W',[],'x',[],'dry',[],'wet',[],'empty',[],'fuel',[],'fuel_1',[],'retardent',[]);
    plane.data.performance = struct('R',[],'E',[],'ROC',[],'v_max',366.667,'v_stall',146.667,'N',5);
    plane.data.aero = struct('CL',[],'CL_alpha',[],'CD',[],'CD0',[],'CDi',[],'v_cruise',[],'LD',[]);
    plane.data.stability = struct('h_n',[],'is_stable',[],'yaw_is_stable',[]);
   


