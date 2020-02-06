tic
clc; clear variables;
fprintf('Optimization Started \n')
% make an empty array of good planes
<<<<<<< HEAD
p = 0;
=======
stable = 0;
>>>>>>> 301659eb37fc4ccf140434cf2760f4a1c7a4e7bb
i = 0;
numPlanes = 100;
resultPlanes = struct('Good',{});

% while we have less than (n) good planes:
while  i < numPlanes
    newPlane = plane();
    newPlane = getRandomPlane(newPlane);

    newPlane = getPropulsionDetails(newPlane);
    
    newPlane = weight_function(newPlane);
    
    newPlane = aerodynamics(newPlane);

    % Iterate for fuel weight
    newPlane = getFuelWeight(newPlane);
    
    newPlane = getPerformance(newPlane);
    
    %   check if plane is good
    newPlane = stability(newPlane);
<<<<<<< HEAD
    % check for imagnary lift or drag values
    
    
    if newPlane.data.stability.is_stable && newPlane.data.aero.isreal
        resultPlanes(p+1).Good = newPlane;
        p = p+1;
=======
    if newPlane.data.stability.is_stable
        resultPlanes(stable+1).Good = newPlane;
        stable = stable + 1;
>>>>>>> 301659eb37fc4ccf140434cf2760f4a1c7a4e7bb
    end
    i = i+1;
    %   store plane if above is good

        
end
%%
% initialize data variables
R = zeros(p,1);
ROC = zeros(p,1);
v_stall = zeros(p,1);
v_max = zeros(p,1);
v_cruise = zeros(p,1);
L = zeros(p,1);
b = zeros(p,1);
W = zeros(p,1);
CL = zeros(100,p);
CD = zeros(100,p);
D = zeros(100,p);
LD = zeros(p,1);

% extract data for n planes
for n = 1:p
   R(n) =  resultPlanes(n).Good.data.performance.R;
   ROC(n) =  resultPlanes(n).Good.data.performance.ROC;
   v_stall(n) =  resultPlanes(n).Good.data.performance.v_stall;
   v_max(n) =  resultPlanes(n).Good.data.performance.v_max;
   L(n) =  resultPlanes(n).Good.geo.body.L;
   b(n) =  resultPlanes(n).Good.geo.wing.b;
   W(n) =  resultPlanes(n).Good.data.weight.W;
   CL(:,n) = resultPlanes(n).Good.data.aero.CL(:,2);
   CD(:,n) = resultPlanes(n).Good.data.aero.CD(:,2);
   D(:,n) = resultPlanes(n).Good.data.aero.D;
   v_cruise(n) = resultPlanes(n).Good.data.aero.v_cruise;
   LD(n) = resultPlanes(n).Good.data.aero.LD;
end
v_ref = linspace(v_stall(1), v_max(1),100);
%%
figure
x = v_cruise;
y = ROC;
z = LD;
qx = linspace(min(x),max(y),50);
qy = linspace(min(x),max(y),50);
F = scatteredInterpolant(x,y,z);
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
qx = linspace(min(x),max(y),50);
qy = linspace(min(x),max(y),50);
F = scatteredInterpolant(x,y,z);
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
hold on
for i = 1:p
    plot(v_ref,D(:,i))
end
toc
%%