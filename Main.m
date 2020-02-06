
clc; clear variables;
fprintf('Optimization Started \n')
% make an empty array of good planes
good = 0;
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
    if newPlane.data.stability.is_stable
        resultPlanes(good+1).Good = newPlane;
        good = good+1;
    end
    i = i+1;
    %   store plane if above is good

        
end
%%
% initialize data variables
R = zeros(1,numPlanes);
ROC = zeros(1,numPlanes);
v_stall = zeros(1,numPlanes);
L = zeros(1,numPlanes);
b = zeros(1,numPlanes);
W = zeros(1,numPlanes);

% extract data for n planes
for n = 1:numPlanes
   R(n) =  resultPlanes(n).Good.data.performance.R;
   ROC(n) =  resultPlanes(n).Good.data.performance.ROC;
   v_stall(n) =  resultPlanes(n).Good.data.performance.v_stall;
   L(n) =  resultPlanes(n).Good.geo.body.L;
   b(n) =  resultPlanes(n).Good.geo.wing.b;
   W(n) =  resultPlanes(n).Good.data.weight.W;
    
end
%%

figure
stem3(R,ROC,v_stall)
xlabel('Range')
ylabel('Rate of Climb')
zlabel('v_stall')
% plot drag / velocity curve

figure
stem3(b,L,W)
ylabel('Length')
ylabel('Span')
zlabel('Weight')

