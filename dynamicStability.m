function stable = dynamicStability(plane)
%Lateral Modes of Motion Example using Pioneer UAV stability derivatives
%Roots computed using 4th order sytstem.
%Roots also computed based on approximate equations derived in class
%D.Toohey

plots = 1; % 1 to plot, 0 to not plot root locus diagrams

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
 sos = 968; % speed of sound ft/s
 
Vt = plane.data.aero.v_cruise(1); %fps
M = Vt/sos;
rho = 0.001267;    %slug/ft^3
qbar = 0.5*rho*Vt^2;

%stability derivatives for Pioneer
% aero data - linear stability coefficients, lateral
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
% aeroa data - longitudinal
ind = plane.data.aero.cruiseind(1);
v_ref = linspace(plane.data.requirements.v_stall, plane.data.requirements.v_max);

C_D = plane.data.aero.CD(:,1);
C_D0 = plane.data.aero.CD0(:,1);
C_D0 = C_D0(ind);
C_Du = (C_D(ind+1)-C_D(ind-1))/(v_ref(ind+1)-v_ref(ind-1));
C_D_alpha = (plane.data.aero.cd(4)-plane.data.aero.cd(3))/1*180/pi;

C_L0 = plane.data.aero.cl(3);
C_L = plane.data.aero.CD(:,1);
C_Lu = (C_L(ind+1)-C_L(ind-1))/(v_ref(ind+1)-v_ref(ind-1));
C_L_alpha = plane.data.aero.cla(3);

C_Ma = plane.data.aero.cma(1);
C_Mu = 0;
C_Mq = plane.data.aero.cmq;


% Control Surface Derivatives
CY_dr   =    0.191;              % [/rad]      Bray pg 33
Cl_da   =   -0.161;              % [/rad]      Bray pg 33 (sign reversed)
Cl_dr   =   -0.00229;            % [/rad]      Bray pg 33
Cn_da   =    0.0200;             % [/rad]      Bray pg 33 (sign reversed)
Cn_dr   =   -0.0917;             % [/rad]      Bray pg 33

%computing dimensional derivatives
X_u = - (C_Du + 2*C_D0)*(qbar*Sw)/(mass*Vt);
X_w = - (C_D_alpha - C_L0)*(qbar*Sw)/(mass*Vt);

Y_b = qbar*Sw/(mass)*Cy_b;
Y_p = 0;
Y_r = 0;

Z_u = - (C_Lu + 2*C_L0)*(qbar*Sw)/(mass*Vt);
Z_w = - (C_L_alpha + C_D0)*(qbar*Sw)/(mass*Vt);

L_b = qbar*Sw*b/(Jx)*Cl_b;
L_p = qbar*Sw*b^2/(2*Jx*Vt)*Cl_p;
L_r = qbar*Sw*b^2/(2*Jx*Vt)*Cl_r;

M_u = C_Mu*qbar*Sw*cbar/(Vt*Jy);
M_w_dot = 0;
M_w = C_Ma*qbar*Sw*cbar/(Vt*Jy);
M_q = C_Mq *qbar*Sw*cbar/(2*Vt*Jy);

N_b = qbar*Sw*b/(Jz)*Cn_b;
N_p = qbar*Sw*b^2/(2*Jz*Vt)*Cn_p;
N_r = qbar*Sw*b^2/(2*Jz*Vt)*Cn_r;

%% Lateral Stability
%Find roots of 4th order system
Alat = [Y_b/Vt Y_p/Vt -(1-Y_r/Vt) g0/Vt;...
        L_b     L_p      L_r          0;...
        N_b     N_p      N_r          0;...
        0       1        0            0];
Blat = [ 0 0;...
    0 0;...
    0 0;...
    0 0];
A = Alat ; 
B = Blat ; 
C = eye(4);
D = zeros(4,2);

[b_lat,a_lat]=ss2tf(A,B,C,D,2);
real_roots_lat = real(roots(a_lat));
imag_roots_lat = imag(roots(a_lat));

numunstablelat = 0;
for r = 1:length(real_roots_lat)
    if real_roots_lat(r) > 0
        numunstablelat = numunstablelat + 1;
    end
end
if numunstablelat > 1 % allow for one slightly unstable pole
   stablelat = false;
else
   stablelat = true;
end

%% Longitudinal Stability
Along = [X_u   X_w       0          -g0;...
         Z_u   Z_w      Vt           0;...
         M_u   M_w      M_q          0;...
         0      0        1           0];
try
    roots_long = eig(Along);
catch
    stable = false;
    return
end
real_roots_long = real(roots_long);
imag_roots_long = imag(roots_long);

numunstablelong = 0;
for r = 1:length(real_roots_long)
    if real_roots_long(r) > 0
        numunstablelong = numunstablelong + 1;
    end
end
if numunstablelong > 0
   stablelong = false; 
else
   stablelong = true;
end


%% Check if lateral and longitudinal are stable
stable = false;
if stablelat && stablelong
    stable = true;
end

%%
if plots
    figure %#ok<*UNRCH>
    hold on
    plot(real_roots_long,imag_roots_long,'bx','Linewidth',5)
    plot(real_roots_lat,imag_roots_lat,'rx','Linewidth',5)
    grid on
    set(gca,'FontSize',13,'FontWeight','bold')
    legend('Longitudinal','Lateral')
    
    figure
    ssLong = ss(Along,B,C,D);
    ssLat = ss(Alat,B,C,D);
    hold on
    pzmap(ssLong);
    pzmap(ssLat);
    a = findobj(gca,'type','line');
    for i = 1:length(a)
        set(a(i),'markersize',12) %change marker size
        set(a(i), 'linewidth',3)  %change linewidth
    end
    legend('Longitudinal','Lateral')
    grid on
    
end


%omegnd = (real_roots_4th(2)^2 + imag_roots_4th(2)^2)^.5;
%omegnr = max(-real_roots_4th);

end