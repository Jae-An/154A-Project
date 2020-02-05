clc; clear all;
% make an empty array of good planes
good = 0;
i = 0;
numPlanes = 5;
resultPlanes = struct('Good',{});

% while we have less than (n) good planes:
while  i < numPlanes
    %   getRandomPlane()
    newPlane = plane();
    newPlane = getRandomPlane(newPlane);
    %   nikolai(plane)
    newPlane = getPropulsionDetails(newPlane);
    
    temp = weight_function(newPlane);
    newPlane = temp(1);
    
    %   aerodynamics(plane)
    newPlane = aerodynamics(newPlane);
    
    %   propulsion(plane)

    
    %   stability(plane)
    %   performance(plane)
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

%plot drag / velocity curve