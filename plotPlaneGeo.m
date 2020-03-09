function [] = plotPlaneGeo(plane)

% fuselage
f_w = plane.geo.body.W; % width
f_D = plane.geo.body.D; % depth
f_L = plane.geo.body.L; % length
f_r = f_w/2; % radius

% wing
w_c = plane.geo.wing.c; % wing chord length
w_b = plane.geo.wing.b; % wing span
w_sweep = plane.geo.wing.sweep; % sweep
w_tr = plane.geo.wing.TR; % taper taio
w_thr = plane.geo.wing.ThR; % thickness ratio

% horizontal tail
h_b = plane.geo.h_tail.b; % span
h_c = plane.geo.h_tail.c; % chord
h_thr = plane.geo.h_tail.ThR;
h_tr = plane.geo.h_tail.TR;
h_sweep = plane.geo.h_tail.sweep; % degrees, sweep length

% vertical tail
v_b = plane.geo.v_tail.b; % span
v_c = plane.geo.v_tail.c;
v_thr = plane.geo.v_tail.ThR;
v_tr = plane.geo.v_tail.TR;
v_sweep = plane.geo.v_tail.sweep; % degrees, sweep length

color = [1 0.8 0.79];
wingColor     = color;
fusColor      = color;
tailWingColor = color;
finColor      = color;
propColor     = color;
edgeColor     = 'k';
linestyle     = '-'; 
scale         = 1; 
zscale        = 1;
plotprop = false;

x = 0; 
y = 0; 
z = 0; 
%% Dimensions: 
w_b = w_b*scale; 
w_c = w_c*scale; % changing wingWidth will affect several dimensions
h_b = h_b*scale; 
h_c = h_c*scale;
f_n = f_L*0.15; % length of fuselage nose
f_L = f_L-f_n-v_c;
f_r = f_r*scale;
% Center the dimensions: 
y = y+w_c*9/5; 
z = z+f_r; 
%% Determine if a figure is already open: 
initialHoldState = 0; 
SetView = isempty(get(gcf,'CurrentAxes'));
    
if ~SetView
    if ishold
        initialHoldState = 1; % documents initial hold state to reset it later 
    else 
        cla % if hold is on initially, clear the axes and make a new plot
        SetView = true;
    end      
end
%% Draw surfaces: 
% Fuselage: 
[xcf,zcf,ycf] = cylinder(f_r);
x_f = xcf+x;
y_f = y-ycf*f_L;
z_f = z+zcf;

h(1) = surface(x_f,y_f,z_f,...
    'facecolor',fusColor,'linestyle',linestyle,...
    'edgecolor',edgeColor);
if ~initialHoldState
    hold on
end
% Nose: 
[xcn,zcn,ycn] = cylinder(f_r.*([1 .95 .9 .8 .7 .5 .1]).*(cos(linspace(0,pi/2,7)).^.2)); 
zcn(6:end,:) = zcn(6:end,:)-f_r/7; 
ycn = -ycn.*f_n;

x_n = x+xcn;
y_n = y-ycn;
z_n = z+zcn;

h(2) = surface(x_n,y_n,z_n*zscale,...
    'facecolor',fusColor,'linestyle',linestyle,...
    'edgecolor',edgeColor);


% Tail
x1 = xcf(1,:); 
x2 = .8*x1;% zeros(size(x1)); 
y1 = f_L*ones(size(x1)); 
y2 = y1+v_c;
z1 = zcf(1,:); 
z2 = f_r*ones(size(z1));

x_ft = x+[x1;x2];
y_ft = y-[y1;y2];
z_ft = z+[z1;z2];

h(3) = surface(x_ft,y_ft,z_ft,...
    'facecolor',fusColor,'linestyle',linestyle,...
    'edgecolor',edgeColor);
% Wings: 
xw1 = -linspace(-w_b/2,w_b/2,10); 
yw1 = f_n/2+abs(xw1)/100;
yw2 = zeros(size(xw1))+f_n/2+w_c/3; 
yw3 = yw1 + w_c-abs(xw1)/20; 
zw1 = .6*f_r*ones(size(xw1));

x_w1 = x+[.99*xw1;xw1;.97*xw1];
y_w1 = y-[yw1;yw2;yw3];
z_w1 = z+[zw1;zw1+.15*f_r;zw1];
x_w2 = x+[.99*xw1;xw1;.97*xw1];
y_w2 = y-[yw1;yw2;yw3];
z_w2 = z+[zw1;zw1;zw1];

h(4) = surface(x_w1,y_w1,z_w1*zscale,'facecolor',wingColor,...
    'linestyle',linestyle,'edgecolor',edgeColor);
h(5) = surface(x_w2,y_w2,z_w2,'facecolor',wingColor,...
    'linestyle',linestyle,'edgecolor',edgeColor);
% tail wing:
xtw1 = -linspace(-h_b/2,h_b/2,5); 
xtw = [xtw1;xtw1;xtw1];
ytw1 = v_c+f_L+ abs(xtw1)/10-h_c;
ytw2 = zeros(size(xtw1))+v_c+ f_L+.88*h_c-h_c;
ytw3 = ytw2+.12*h_c-abs(xtw1)/10;
ytw = [ytw1; ytw2;ytw3]; 
ztw1 = f_r*ones(size(xtw1)); 
h(6) = surface(x+xtw,y-ytw,z+[ztw1;ztw1+.05*f_r;ztw1]*zscale,...
    'facecolor',tailWingColor,'linestyle',linestyle,...
    'edgecolor',edgeColor); 
h(7) = surface(x+xtw,y-ytw,z+[ztw1;ztw1;ztw1]*zscale,...
    'facecolor',tailWingColor,'linestyle',linestyle,...
    'edgecolor',edgeColor);
% Vertical Fin: 
yts = f_L+v_c*[1 .8 0]; 
yts = [yts;yts]; 
zts = f_r*[1 1 1]; 
zts(2,:)= zts+1.1*v_b*[1 1 0]; 
xts = [0 f_r/20 0;0 f_r/40 0]; 
h(8) = surface(x+xts,y-yts,z+zts*zscale,...
    'facecolor',finColor,'linestyle',linestyle,...
    'edgecolor',edgeColor);
h(9) = surface(x-xts,y-yts,z+zts*zscale,...
    'facecolor',finColor,'linestyle',linestyle,...
    'edgecolor',edgeColor);
% Propellers:
if plotprop == true
    xp = .4*w_c*sin(0:.2:2*pi); 
    zp = .4*w_c*cos(0:.2:2*pi)+.4*w_c; 
    yp = zeros(size(xp))-1.2*w_c; 
    h(10) = patch(x+xp-w_c,y+yp,z+zp*zscale,propColor); 
    h(11) = patch(x+xp+w_c,y+yp,z+zp*zscale,propColor); 
    h(12) = patch(x+xp-w_c,y+yp,z+zp*zscale,propColor); 
    h(13) = patch(x+xp+w_c,y+yp,z+zp*zscale,propColor); 
    set(h(10:13),'facealpha',.2,'edgealpha',.5)
end

%% Set view
view([140 30]); 
axis tight equal
lighting gouraud
camlight

%% Clean up: 
% Return axes to initial hold state
if ~initialHoldState
    hold off
end

% 
% xlabel('x')
% ylabel('y')
% zlabel('z')
end
