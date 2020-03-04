tic
clc; clear variables;
fprintf('Optimization Started \n')
% make an empty array of good planes

p = 0;
stable = 0;
i = 0;
numPlanes = 20;
resultPlanes = struct('Good',{});

% while we have less than (n) good planes:
while  i < numPlanes
    newPlane = plane();
    newPlane = getRandomPlane(newPlane);

    newPlane = getPropulsionDetails(newPlane);
        % note: need to randomize fuel mass
    
    newPlane = weight_function(newPlane);
    
    newPlane = aerodynamics(newPlane);

    newPlane = getPerformance(newPlane);
    
    %   check if plane performance and stability is good
    newPlane = stability(newPlane);
    [rocGood, VcGood,GeoIsGood] = isGood(newPlane);
    
    
    % check for imagnary lift or drag values
    if newPlane.data.aero.isreal
        % check if plane is "good"
        if newPlane.data.stability.is_stable && rocGood && VcGood && GeoisGood
        
            resultPlanes(p+1).Good = newPlane; %   store plane if above is good
            p = p+1;
            i = i+1;
        end
    end
    
    
    
    if isreal(newPlane.data.aero.CD) && isreal(newPlane.data.aero.CL)
        
        CD = newPlane.data.aero.CD;
        v_stall = newPlane.data.requirements.v_stall;
        v_max = newPlane.data.requirements.v_max;
        v = linspace(v_stall,v_max);
        
        %figure;
        %plot(v,CD);
        
    end
        
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