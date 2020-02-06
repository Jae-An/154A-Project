function plane = getAngles(plane)
% Calculates angles(alpha, i, etc.) for required lift

aero = plane.data.aero;
wing = plane.geo.wing;
tail = plane.geo.h_tail;
h_n = plane.data.stability.h_n;

CM_ac = wing.cm_ac;
CL_a = wing.cl_a + tail.cl_a*(tail.S/wing.S)*(1-tail.e_a);
CM_a = -CL_a*(h_n-wing.h_cg);
CL = aero.CL; % this is an array!
CM_i = tail.cl_a*(tail.l_t/wing.c)*(tail.S/wing.S); %WE NEED tail.l_t
CL_i = -tail.cl_a*(tail.S/wing.S);

i = -(CM_ac*CL_a + CM_a*CL)/(CL_a*CM_i - CM_a*CL_i); %required incidence angles
a = (CL - CL_i*i)/CL_a; %required angles of attack
a_t = a*(1-tail.e_a) - i; %required tail angles of attack

aero.CL_a = CL_a;
if all(a < wing.a_stall) && all(a_t < tail.a_stall)
    plane.data.test.no_stall = true;
else
    plane.data.test.no_stall = false;
end
end