%map display function -- D.Toohey
function  out = show_map(in)

pn = in(1);
pe = in(2);
alt = in(3);
tar_E = in(4);
tar_N = in(5);


figure(1)
subplot(211)

plot(pe,pn,'.b')
hold on
plot(tar_E,tar_N,'xr')
xlabel('pE')
ylabel('pN')
ylim([-1000 50000])
xlim([-1000 25000])
axis equal
grid on
subplot(212)
hold on
plot(pn,alt,'.r')
xlabel('pN (ft)')
ylabel('Alt (ft)')
xlim([-50 30000])
ylim([0 1500])
grid on

% figure(2)
% hold on
% stem3(pe,pn,alt,'b')
% ylim([-1000 30000])
% xlim([-1000 30000])
% zlim([0 1500])
% view([-150 10]);

out = pn;