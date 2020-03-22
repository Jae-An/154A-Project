function stable = dynamicStability(plane)
%Lateral Modes of Motion Example using Pioneer UAV stability derivatives
%Roots computed using 4th order sytstem.
%Roots also computed based on approximate equations derived in class
%D.Toohey
b   =  plane.geo.wing.b;    % [ft]        Bray pg 31
cbar =  plane.geo.wing.c;     % [ft]        Bray pg 31
Sw   =  plane.geo.wing.S;    % [ft^2]      Bray pg 31
%pioneer values
W = plane.data.weight.wet;     % [lbsf]        Bray pg 33
Jx = plane.geo.Ixx(1);    % [slug-ft^2] IAI, MSS notes
Jy = plane.geo.Iyy(1);     % [slug-ft^2] IAI, MSS notes
Jz = plane.geo.Izz(1);     % [slug-ft^2] IAI, MSS notes
Jxz = plane.geo.Ixz(1);    % [slug-ft^2] IAI, MSS notes


 g0 = 32.17405;   %ft/s^2
 mass = W/g0; 
 alpha_e = 0.0;
 gamma_e = 0.0;

Vt = plane.data.aero.v_cruise(1); %fps
rho = 0.002379;    %slug/ft^3
qbar = 0.5*rho*Vt^2;

%stability derivatives for Pioneer
% aero data - linear stability coefficients
a = 3;
Cl_b = plane.data.aero.clb(a);
Cl_p = plane.data.aero.clp(a);
Cl_r = plane.data.aero.clr(a);
Cn_b = plane.data.aero.cnb;
Cn_p = plane.data.aero.cnp(a);
Cn_r = plane.data.aero.cnr(a);
beta = -1;
Cy_b = plane.data.aero.clwb(a)/beta;
Cy_p = plane.data.aero.cyp(a);
%Cy_r = plane.data.aero.cyr(a);

% Control Surface Derivatives
CY_dr   =    0.191;              % [/rad]      Bray pg 33
Cl_da   =   -0.161;              % [/rad]      Bray pg 33 (sign reversed)
Cl_dr   =   -0.00229;            % [/rad]      Bray pg 33
Cn_da   =    0.0200;             % [/rad]      Bray pg 33 (sign reversed)
Cn_dr   =   -0.0917;             % [/rad]      Bray pg 33
%computing dimensional derivatives
Y_b = qbar*Sw/(mass)*Cy_b;
Y_p = 0;
Y_r = 0;

L_b = qbar*Sw*b/(Jx)*Cl_b;
L_p = qbar*Sw*b^2/(2*Jx*Vt)*Cl_p;
L_r = qbar*Sw*b^2/(2*Jx*Vt)*Cl_r;

N_b = qbar*Sw*b/(Jz)*Cn_b;
N_p = qbar*Sw*b^2/(2*Jz*Vt)*Cn_p;
N_r = qbar*Sw*b^2/(2*Jz*Vt)*Cn_r;

%% Lateral Stability
%Find roots of 4th order system
    A_mat = [Y_b/Vt Y_p/Vt -(1-Y_r/Vt) g0/Vt;...
            L_b     L_p      L_r          0;...
            N_b     N_p      N_r          0;...
            0       1        0            0];

    B_mat = [ 0 0;...
        0 0;...
        0 0;...
        0 0];
A = A_mat ; 
B = B_mat ; 
C = eye(4);
D = zeros(4,2);

[b_tf,a_tf]=ss2tf(A,B,C,D,2);
real_roots_4th = real(roots(a_tf));
imag_roots_4th = imag(roots(a_tf));

stable = true;
numunstable = 0;
for r = 1:length(real_roots_4th)
    if real_roots_4th(r) > 0
        numunstable = numunstable + 1;
    end
end
if numunstable > 1
   stable = false; 
end

%%
% figure
% plot(real_roots_4th,imag_roots_4th,'mx','Linewidth',2)
% grid on

%%
% 
% figure(3)
% sys = ss(A,B,C,D);
% pzmap(sys);
% hold on
% grid on
% 
% omegnd = (real_roots_4th(2)^2 + imag_roots_4th(2)^2)^.5;
% omegnr = max(-real_roots_4th);
end