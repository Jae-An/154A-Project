
% make an empty array of good planes
N = 1; % number of resulting planes
good = 0;
all = 0;
resultPlanes = struct('good',[]);

% while we have less than (n) good planes:
while good < N && all < 100
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
        good = good+1;
    end
    %   store plane if above is good
    all = all+1;
end
%plot drag / velocity curve