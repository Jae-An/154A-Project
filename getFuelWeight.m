function [plane] = getFuelWeight(plane)
% Iterate to find fuel weight

err = 10; % lb tolerance


while 1
    weight = plane.prop.fuel_mass;
    plane = getBregeutFuelWeight(plane);
    plane = weight_function(plane);
    plane = aerodynamics(plane);
    if abs(weight-plane.prop.fuel_mass)<err   
        break;
    end
end

end

function [plane] = getBregeutFuelWeight(plane)
%Use Bregeut range equation to calculate fuel ratio needed in two parts

%Initializations
prop = plane.prop;
cp = prop.c_p / (550*60*60);
CL = plane.data.aero.CL; %THESE ARE REQUIRED VALUES
CD = plane.data.aero.CD;
weightPayload = plane.data.weight.retardent;
weightFinal = plane.data.weight.empty;

CL_CD_1 = CL(end,1)/CD(end,1); %Cruise CL/CD for wet
CL_CD_2 = CL(end,2)/CD(end,2); %Cruise CL/CD for dry

R = 500*5280; %mi * ft/mi (range)

% First leg (with retardent)
eta = max(prop.eta_p); % assuming eta at cruise conditions (maximum eta

weightRatio1 = exp((R/2)*(cp/eta)/(CL_CD_1));
% Second leg (no retardent)
weightRatio2 = exp((R/2)*(cp/eta)/(CL_CD_2));

% Overall
weightRatio = weightRatio1*(weightRatio2 + (weightPayload/weightFinal));
weightInitial = weightRatio*weightFinal;
plane.prop.fuel_mass = weightInitial - (weightFinal+weightPayload);
end