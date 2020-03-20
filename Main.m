tic
clc; clear variables; close all;
fprintf('Optimization Started \n')
% make an empty array of good planes
stable = 0;
g = 0; % good planes
b = 0; % bad planes
numGoodPlanes = 50;
resultPlanes = struct(['Good','Bad'],{});

% while we have less than (n) good planes:
fprintf('Finding good planes... \n')
while  g < numGoodPlanes
    fprintf('.')
    if mod(g+b,100) == 0
        fprintf('\n')
    end
    
    newPlane = plane();
    newPlane = getRandomPlane(newPlane);
    newPlane = getPropulsionDetails(newPlane);
    newPlane = weight_function(newPlane);
    newPlane = aerodynamics(newPlane);
    newPlane = getCG(newPlane);
    newPlane = getPerformance(newPlane); 
    % check if plane performance and stability is good
    newPlane = stability(newPlane);
       
    % check for imagnary lift or drag values
    if isGood(newPlane)
       resultPlanes(g+1).Good = newPlane; %   store plane if above is good
       g = g+1;
    else
       resultPlanes(b+1).Bad = newPlane;
       b = b+1;
    end    
end
%%
fprintf('\n\n%d good planes found \n',g)
fprintf('%d bad planes discarded \n',b)

%%
% initialize data variables
R = zeros(g,1);
RE = zeros(g,1);
ROC = zeros(g,1);
v_stall = zeros(g,1);
v_max = zeros(g,1);
v_cruise = zeros(g,2);
L = zeros(g,1);
d = zeros(g,1);
b = zeros(g,1);
c = zeros(g,1);
W = zeros(g,1);
S = zeros(g,1);
AR = zeros(g,1);
CL = zeros(100,g);
CD = zeros(100,g);
D = zeros(100,g);
LD = zeros(g,1);
sweep = zeros(g,1);
LE = zeros(g,1);

% extract data for n planes
for n = 1:g
   R(n) =  resultPlanes(n).Good.data.performance.R; % ft
   ROC(n) =  resultPlanes(n).Good.data.performance.ROC;
   RE(n) =  resultPlanes(n).Good.data.aero.Re_cruise(1);
   v_stall(n) =  resultPlanes(n).Good.data.performance.v_stall;
   v_max(n) =  resultPlanes(n).Good.data.performance.v_max;
   L(n) =  resultPlanes(n).Good.geo.body.L;
   d(n) = resultPlanes(n).Good.geo.body.W;
   S(n) =  resultPlanes(n).Good.geo.wing.S;
   AR(n) = resultPlanes(n).Good.geo.wing.AR;
   b(n) =  resultPlanes(n).Good.geo.wing.b;
   c(n) =  resultPlanes(n).Good.geo.wing.c;
   LE(n) =  resultPlanes(n).Good.geo.wing.LE;
   sweep(n) =  resultPlanes(n).Good.geo.wing.sweep;
   W(n) =  resultPlanes(n).Good.data.weight.wet;
   CL(:,n) = resultPlanes(n).Good.data.aero.CL(:,2);
   CD(:,n) = resultPlanes(n).Good.data.aero.CD(:,2);
   D(:,n:n+1) = resultPlanes(n).Good.data.aero.D;
   v_cruise(n,:) = resultPlanes(n).Good.data.aero.v_cruise;
   LD(n) = resultPlanes(n).Good.data.aero.LD(1);
end
v_ref = linspace(v_stall(1), v_max(1),100);
%%
figure
x = v_cruise;
y = R./5280;
z = ROC.*60;
qx = linspace(min(x(:,1)),max(x(:,1)),100); %picked the first column but this should be fixed more properly
qy = linspace(min(y),max(y),100);

F = scatteredInterpolant(x(:,1),y,z);
[Xq,Yq] = meshgrid(qx, qy);
F.Method = 'natural';
Z = F(Xq,Yq);
meshc(Xq,Yq,Z)
xlabel('Cruise Speed ft/s')
zlabel('Rate of Climb, fpm')
ylabel('Range, miles')
shading interp
set(gca, 'FontSize', 17, 'FontWeight', 'bold')
%%
figure
x = b;
y = L;
z = v_cruise;
qx = linspace(min(x(:,1)),max(y),50);
qy = linspace(min(x(:,1)),max(y),50);
F = scatteredInterpolant(x(:,1),y,z(:,1));
[Xq,Yq] = meshgrid(qx, qy);
F.Method = 'natural';
Z = F(Xq,Yq);
meshc(Xq,Yq,Z)
zlabel('Cruise Speed ft/s')
xlabel('Span, ft')
ylabel('Length, ft')
shading interp
set(gca, 'FontSize', 17, 'FontWeight', 'bold')
%%
figure
plot(LD,R/5280,'*')
xlabel('Lift-to-Weight')
ylabel('Range, Miles')
%%
figure
bar(1:g,R/5280)
ylabel('Range (miles)')
%%
figure
bar(1:g,ROC.*60)
ylabel('Rate of Climb, fpm')

%%
figure
bar(1:g,v_cruise)
ylabel('Cruise Velocity, ft/s')

%%
figure
bar(1:g,W)
ylabel('Wet Weight, lb')
%%
N=g;
hf=figure('units','normalized','outerposition',[0 0 1 1]);
hf.ToolBar='none';
nS   = sqrt(N);
nCol = ceil(nS);
nRow = nCol - (nCol * nCol - N > nCol - 1);
for k = 1:N-2
  subplot(nRow, nCol, k);
  plotPlaneGeo(resultPlanes(k).Good);
  set(gca,'XTick',[], 'YTick', [], 'ZTick', [])
  title(k)
end

%%
figure
hold on
for n = 1:g
    plot(v_ref,D(:,n))
end
eta = resultPlanes(1).Good.prop.eta_p; % eta and hp same for all planes so I just used the first one
hp = resultPlanes(1).Good.prop.hp;
thrust = (hp * 550 * eta) ./ v_ref;
plot(v_ref,thrust);
hold off
toc
%%

%% 
 