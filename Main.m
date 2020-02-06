
clc; clear variables;
a = 'started sim'
% make an empty array of good planes
good = 0;
i = 0;
numPlanes = 10;
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
    if newPlane.data.stability.is_stable && newPlane.data.performance.ROC > 20
        resultPlanes(good+1).Good = newPlane;
        good = good+1;
    end
    i = i+1;
    %   store plane if above is good
    
    if isreal(newPlane.data.aero.CD) && isreal(newPlane.data.aero.CL)
        
        CD = newPlane.data.aero.CD;
        v_stall = newPlane.data.requirements.v_stall;
        v_max = newPlane.data.requirements.v_max;
        v = linspace(v_stall,v_max);
        
        figure;
        plot(v,CD);
        
    end
        
end

%plot drag / velocity curve