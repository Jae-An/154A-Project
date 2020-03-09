function plane = makeTestPlane()

plane = struct('geo',[],'prop',[],'data',[]);

%% Aircraft Geometry
plane.geo = struct('body',[],'wing',[],'h_tail',[],'v_tail',[]);
plane.geo.body = struct('L',43.5,'W',15,'D',15);
plane.geo.wing = struct('S',485,'AR',10,'c',6,'b',36,'thickness',1,'taper',.75,'sweep',0,'cg',6,'ac',8,'h_cg',1,'h_ac',1.3,'alpha',5);
plane.geo.h_tail = struct('S',80,'AR',6,'c',4,'b',10,'thickness',.75,'taper',.9,'sweep',0,'cg',20,'ac',20,'h_cg',3.3,'h_ac',3.3,'alpha',3);
plane.geo.v_tail = struct('S',40,'AR',3,'c',4,'b',12,'thickness',.75,'taper',1,'sweep',0,'cg',20,'ac',20,'h_cg',3.3,'h_ac',3.3,'alpha',3);

%% Propulsion
plane.prop = struct('W',[],'hp',[],'eta_p',[],'c_p',[],'fuel_mass',[]);

%% DATA
plane.data = struct('W',30000,'CL',1,'CD',0.5,'CD0',0.1,'CDi',3,'CL_alpha',5,'h_n',30,'N',5,'v_max',217.244,'v_stall',86.8976); % *fill out later*

getPropulsionDetails(plane);

end

