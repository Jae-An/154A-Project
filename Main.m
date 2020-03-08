tic
clc; clear variables;
fprintf('Optimization Started \n')
% make an empty array of good planes
stable = 0;
g = 0;
b = 0;
numGoodPlanes = 100;
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
    % TODO: need to randomize fuel mass
    newPlane = weight_function(newPlane);
    newPlane = aerodynamics(newPlane);
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
    
    
    
    if isreal(newPlane.data.aero.CD) && isreal(newPlane.data.aero.CL)
        CD = newPlane.data.aero.CD;
        v_stall = newPlane.data.requirements.v_stall;
        v_max = newPlane.data.requirements.v_max;
        v = linspace(v_stall,v_max);
        
    end
        
end
%%
fprintf('\n\n%d good planes found \n',g)
fprintf('%d bad planes discarded \n',b)

%%
% initialize data variables
R = zeros(g,1);
ROC = zeros(g,1);
v_stall = zeros(g,1);
v_max = zeros(g,1);
v_cruise = zeros(g,2);
L = zeros(g,1);
b = zeros(g,1);
W = zeros(g,1);
CL = zeros(100,g);
CD = zeros(100,g);
D = zeros(100,g);
LD = zeros(g,1);

% extract data for n planes
for n = 1:g
   R(n) =  resultPlanes(n).Good.data.performance.R./5280; % miles
   ROC(n) =  resultPlanes(n).Good.data.performance.ROC;
   v_stall(n) =  resultPlanes(n).Good.data.performance.v_stall;
   v_max(n) =  resultPlanes(n).Good.data.performance.v_max;
   L(n) =  resultPlanes(n).Good.geo.body.L;
   b(n) =  resultPlanes(n).Good.geo.wing.b;
   W(n) =  resultPlanes(n).Good.data.weight.W;
   CL(:,n) = resultPlanes(n).Good.data.aero.CL(:,2);
   CD(:,n) = resultPlanes(n).Good.data.aero.CD(:,2);
   D(:,n:n+1) = resultPlanes(n).Good.data.aero.D;
   v_cruise(n,:) = resultPlanes(n).Good.data.aero.v_cruise;
   LD(n) = resultPlanes(n).Good.data.aero.LD;
end
v_ref = linspace(v_stall(1), v_max(1),100);
%%
figure
x = v_cruise;
y = ROC;
z = LD;
qx = linspace(min(x(:,1)),max(y),50); %picked the first column but this should be fixed more properly
qy = linspace(min(x(:,1)),max(y),50);

F = scatteredInterpolant(x(:,1),y,z);
[Xq,Yq] = meshgrid(qx, qy);
F.Method = 'natural';
Z = F(Xq,Yq);
meshc(Xq,Yq,Z)
xlabel('Cruise Speed ft/s')
ylabel('Rate of Climb fpm')
zlabel('Lift Over Drag')
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
plot(LD,R,'*')
xlabel('Lift-to-Weight')
ylabel('Range, Miles')
%%
figure
bar(1:g,R)

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