
% make an empty array of good planes
N = 1; % number of resulting planes
good = 0;
resultPlanes = struct('good',[],'all',[]);

% while we have less than (n) good planes:
while good < N
    %   getRandomPlane()
    newPlane = plane();
    newPlane = getRandomPlane(newPlane);
    %   nikolai(plane)
    newPlane = getPropulsionDetails(newPlane);
    newPlane = weight_function(newPlane);
    %   aerodynamics(plane)
    newPlane = aerodynamics(newPlane);
    %   propulsion(plane)

    
    %   stability(plane)
    %   performance(plane)
    %   check if plane is good
    if stability(newPlane)
        resultPlanes.good(good+1) = newPlane;
    end
    resultPlanes.all(end+1) = newPlane;
    %   store plane if above is good
end
%plot drag / velocity curve