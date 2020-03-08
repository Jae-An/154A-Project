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
ylim([-15000 15000])
xlim([-15000 15000])
axis equal
grid on
subplot(212)
hold on
plot(pn,alt,'.r')
xlabel('pN (ft)')
ylabel('Alt (ft)')
xlim([-15000 15000])
ylim([500 1500])
grid on


out = pn;