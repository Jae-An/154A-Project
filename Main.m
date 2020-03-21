tic
clc; clear variables; close all;
fprintf('Optimization Started \n')
% make an empty array of good planes
stable = 0;
g = 0; % good planes
b = 0; % bad planes

numGoodPlanes = 2000;
resultPlanes = struct(['Good','Bad'],{});

% while we have less than (n) good planes:
fprintf('Finding good planes... \n')
while  g < numGoodPlanes
    %fprintf('.')

    
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
W = zeros(g,1);
fuel_weight = zeros(g,1);
R = zeros(g,1);
RE = zeros(g,1);
ROC = zeros(g,1);
v_stall = zeros(g,1);
v_max = zeros(g,1);
v_cruise = zeros(g,2);
L = zeros(g,1);
d = zeros(g,1);
wing_S = zeros(g,1);
wing_AR = zeros(g,1);
wing_b = zeros(g,1);
wing_c = zeros(g,1);
wing_sweep = zeros(g,1);
wing_LE = zeros(g,1);
wing_TR = zeros(g,1);

h_tail_S = zeros(g,1);
h_tail_AR = zeros(g,1);
h_tail_b = zeros(g,1);
h_tail_c = zeros(g,1);
h_tail_sweep = zeros(g,1);
h_tail_LE = zeros(g,1);
h_tail_TR = zeros(g,1);

v_tail_S = zeros(g,1);
v_tail_AR = zeros(g,1);
v_tail_b = zeros(g,1);
v_tail_c = zeros(g,1);
v_tail_sweep = zeros(g,1);
v_tail_LE = zeros(g,1);
v_tail_TR = zeros(g,1);

CL = zeros(100,g);
CD = zeros(100,g);
D1 = zeros(100,g);
LD = zeros(g,1);

% extract data for n planes
for n = 1:g
   fuel_weight(n) = resultPlanes(n).Good.data.weight.fuel;
   R(n) =  resultPlanes(n).Good.data.performance.R; % ft
   ROC(n) =  resultPlanes(n).Good.data.performance.ROC;
   RE(n) =  resultPlanes(n).Good.data.aero.Re_cruise(1);
   v_stall(n) =  resultPlanes(n).Good.data.performance.v_stall;
   v_max(n) =  resultPlanes(n).Good.data.performance.v_max;
   L(n) =  resultPlanes(n).Good.geo.body.L;
   d(n) = resultPlanes(n).Good.geo.body.W;
   
   wing_S(n) =  resultPlanes(n).Good.geo.wing.S;
   wing_AR(n) = resultPlanes(n).Good.geo.wing.AR;
   wing_b(n) =  resultPlanes(n).Good.geo.wing.b;
   wing_c(n) =  resultPlanes(n).Good.geo.wing.c;
   wing_LE(n) =  resultPlanes(n).Good.geo.wing.LE;
   wing_sweep(n) =  resultPlanes(n).Good.geo.wing.sweep;
   wing_TR(n) =  resultPlanes(n).Good.geo.wing.TR;
   
   h_tail_S(n) =  resultPlanes(n).Good.geo.h_tail.S;
   h_tail_AR(n) = resultPlanes(n).Good.geo.h_tail.AR;
   h_tail_b(n) =  resultPlanes(n).Good.geo.h_tail.b;
   h_tail_c(n) =  resultPlanes(n).Good.geo.h_tail.c;
   h_tail_LE(n) =  resultPlanes(n).Good.geo.h_tail.LE;
   h_tail_sweep(n) =  resultPlanes(n).Good.geo.h_tail.sweep;
   h_tail_TR(n) =  resultPlanes(n).Good.geo.h_tail.TR; 
   
   v_tail_S(n) =  resultPlanes(n).Good.geo.v_tail.S;
   v_tail_AR(n) = resultPlanes(n).Good.geo.v_tail.AR;
   v_tail_b(n) =  resultPlanes(n).Good.geo.v_tail.b;
   v_tail_c(n) =  resultPlanes(n).Good.geo.v_tail.c;
   v_tail_LE(n) =  resultPlanes(n).Good.geo.v_tail.LE;
   v_tail_sweep(n) =  resultPlanes(n).Good.geo.v_tail.sweep;   
   v_tail_TR(n) =  resultPlanes(n).Good.geo.v_tail.TR; 

   W(n) =  resultPlanes(n).Good.data.weight.wet;
%    CL(n,:) = resultPlanes(n).Good.data.aero.CL(:,1);
%    CD(:,n) = resultPlanes(n).Good.data.aero.CD(:,1);
%    D1(:,n) = resultPlanes(n).Good.data.aero.D(:,1);
%    v_cruise(n,:) = resultPlanes(n).Good.data.aero.v_cruise;
%    LD(n) = resultPlanes(n).Good.data.aero.LD(1);
end
[W, wI] = sort(W);

dummy = resultPlanes;
for n = 1:g
    resultPlanes(n).Good = dummy(wI(n)).Good;
end

fuel_weight = fuel_weight(wI);
R = R(wI);
ROC = ROC(wI);
RE = RE(wI);
v_stall = v_stall(wI);
v_max = v_max(wI);
L = L(wI);
d = d(wI);

wing_S = wing_S(wI);
wing_AR = wing_AR(wI);
wing_b = wing_b(wI);
wing_c = wing_c(wI);
wing_LE = wing_LE(wI);
wing_sweep = wing_sweep(wI);
wing_TR = wing_TR(wI);

h_tail_S = h_tail_S(wI);
h_tail_AR = h_tail_AR(wI);
h_tail_b = h_tail_b(wI);
h_tail_c = h_tail_c(wI);
h_tail_LE = h_tail_LE(wI);
h_tail_sweep = h_tail_sweep(wI);
h_tail_TR = h_tail_TR(wI);

v_tail_S = v_tail_S(wI);
v_tail_AR = v_tail_AR(wI);
v_tail_b = v_tail_b(wI);
v_tail_c = v_tail_c(wI);
v_tail_LE = v_tail_LE(wI);
v_tail_sweep = v_tail_sweep(wI);
v_tail_TR = v_tail_TR(wI);
% CL = CL(:,wI);
% CD = CD(:,wI);

v_ref = linspace(v_stall(1), v_max(1),100);
%%
% figure
% x = v_cruise;
% y = R./5280;
% z = ROC.*60;
% qx = linspace(min(x(:,1)),max(x(:,1)),100); %picked the first column but this should be fixed more properly
% qy = linspace(min(y),max(y),100);
% 
% F = scatteredInterpolant(x(:,1),y,z);
% [Xq,Yq] = meshgrid(qx, qy);
% F.Method = 'natural';
% Z = F(Xq,Yq);
% meshc(Xq,Yq,Z)
% xlabel('Cruise Speed ft/s')
% zlabel('Rate of Climb, fpm')
% ylabel('Range, miles')
% shading interp
% set(gca, 'FontSize', 17, 'FontWeight', 'bold')
%%
% figure
% x = b;
% y = L;
% z = v_cruise;
% qx = linspace(min(x(:,1)),max(y),50);
% qy = linspace(min(x(:,1)),max(y),50);
% F = scatteredInterpolant(x(:,1),y,z(:,1));
% [Xq,Yq] = meshgrid(qx, qy);
% F.Method = 'natural';
% Z = F(Xq,Yq);
% meshc(Xq,Yq,Z)
% zlabel('Cruise Speed ft/s')
% xlabel('Span, ft')
% ylabel('Length, ft')
% shading interp
% set(gca, 'FontSize', 17, 'FontWeight', 'bold')
%%
% figure
% plot(LD,R/5280,'*')
% xlabel('Lift-to-Weight')
% ylabel('Range, Miles')
%%
figure
bar(1:g,R/5280)
ylabel('Range (miles)')
%%
figure
bar(1:g,ROC.*60)
ylabel('Rate of Climb, fpm')

%%
% figure
% bar(1:g,v_cruise)
% ylabel('Cruise Velocity, ft/s')

%%
figure
bar(1:g,W)
ylabel('Wet Weight, lb')
%%
% N=g;
% hf=figure('units','normalized','outerposition',[0 0 1 1]);
% hf.ToolBar='none';
% nS   = sqrt(N);
% nCol = ceil(nS);
% nRow = nCol - (nCol * nCol - N > nCol - 1);
% for k = 1:N-2
%   subplot(nRow, nCol, k);
%   plotPlaneGeo(resultPlanes(k).Good);
%   set(gca,'XTick',[], 'YTick', [], 'ZTick', [])
%   title(k)
% end

%%
% figure
% hold on
% for n = 1:g
%     plot(v_ref,D1(:,n))
% end
% eta = resultPlanes(1).Good.prop.eta_p; % eta and hp same for all planes so I just used the first one
% hp = resultPlanes(1).Good.prop.hp;
% thrust = (hp * 550 * eta) ./ v_ref;
% plot(v_ref,thrust);
% hold off
toc
%%

%% 
 