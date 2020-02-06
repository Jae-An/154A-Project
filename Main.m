
clc; clear variables;
a = 'started sim'
% make an empty array of good planes
stable = 0;
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
    if newPlane.data.stability.is_stable
        resultPlanes(stable+1).Good = newPlane;
        stable = stable + 1;
    end
    i = i+1;
    %   store plane if above is good

        
end

%plot drag / velocity curve