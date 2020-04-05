%waypoint guidance
%D.Toohey

function  out = wayguid(in)

way_num = in(1);
pE = in(2);
pN = in(3);
heading = in(4);
pA = in(5);


if way_num == 0
    way_num = 1;
end

%pre-defined waypoints  (pE   pN)
% waypoints = [-5000 5000;...
%              -10000 10000;...
%              5000 10000;...
%              10000 10000;...
%              12000 8000;...
%              10000 6000;...
%              8000  3000];

waypoints =       [0 1000 50;...
                   0 15000 1000;...
                   0 15000 1000;...
                   0 25000 200;...
                   0 30000 200;...
                   10000 30000 1000;...
                   0 10000 1000;...
                   0    0    0];
               % X Y ALT, ft

% distance threshold used to switch to next waypoint
dist_thresh = 50;

         
tar_E = waypoints(way_num,1);
tar_N = waypoints(way_num,2);
tar_A = waypoints(way_num,3);

delta_E = tar_E - pE;
delta_N = tar_N - pN;
delta_A = tar_A - pA;

way_dist = (delta_E^2 + delta_N^2 + delta_A^2)^.5;
if way_dist < dist_thresh
    way_num = way_num + 1;
end

tar_head = atan2(delta_E,delta_N);

delta_psi = tar_head - heading;


%check for angles larger than 180 deg
if delta_psi > pi
    delta_psi = delta_psi - 2*pi;
elseif delta_psi < -pi
    delta_psi = delta_psi + 2*pi;
end

phi_comm = .6*delta_psi;

if phi_comm > 30*pi/180
    phi_comm = 30*pi/180;
elseif phi_comm < -30*pi/180
    phi_comm = -30*pi/180;
end

alt_comm = tar_A;

out(1) = way_num;
out(2) = phi_comm;
out(3) = tar_E;
out(4) = tar_N;
out(5) = alt_comm;
         
         
   
   
       
