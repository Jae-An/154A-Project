vref = linspace(146,366.7);
load('bessie')
CL = bessie.data.aero.CL; CD = bessie.data.aero.CD; CD0 = bessie.data.aero.CD0;CDi = bessie.data.aero.CDi;LD = CL/CD;

figure(1);
plot(vref,CL(:,1),'LineWidth',3);
hold on;
title('CL vs Velocity','FontSize',12); xlabel('Velocity (ft/s)','FontSize',12); ylabel('Coefficient of Lift','FontSize',14);
plot(vref,CL(:,2),'LineWidth',3);
legend('Wet','Dry');
axis([146 360 0 6]);


figure(2);
plot(vref,CD(:,1),'LineWidth',3);
hold on;
title('CD vs Velocity','FontSize',14); xlabel('Velocity (ft/s)','FontSize',12); ylabel('Coefficient of Drag','FontSize',12);
plot(vref,CD(:,2),'LineWidth',3);
legend('Wet','Dry');


figure(3);
plot(CL(:,1),CD(:,1),'LineWidth',3);
hold on;
title('CD vs CL','FontSize',14); xlabel('Coefficient of Lift','FontSize',12); ylabel('Coefficient of Drag','FontSize',12);
plot(CL(:,2),CD(:,2),'LineWidth',3);
legend('Wet','Dry');

figure(4);
plot(vref,CD0(:,1),'LineWidth',3);plot(vref,CD0(:,2),'LineWidth',3)
hold on;
yyaxis right;
plot(vref,CDi(:,1),'LineWidth',3);plot(vref,CDi(:,2),'LineWidth',3)
title('CD0 and CDi vs Velocity'); xlabel('Velocity (ft/s)'); ylabel('Coefficient of Drag');
plot(CL(:,2),CD(:,2),'LineWidth',3);
legend('Wet - CD0','Dry - CD0','Wet - CDi', 'Dry - CDi');


figure(5);
plot(vref,LD(:,1),'LineWidth',3);
hold on
plot(vref,LD(:,2),'LineWidth',3);
hold on;
title('Cl/CD vs Velocity'); xlabel('Velocity (ft/s)'); ylabel('CL/CD');
plot(CL(:,2),CD(:,2),'LineWidth',3);
legend('Wet','Dry');