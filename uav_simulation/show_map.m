%map display function -- D.Toohey
function  out = show_map(in)
x=1;
pn = in(1)/x;
pe = in(2)/x;
alt = in(3);
tar_E = in(4)/x;
tar_N = in(5)/x;


figure(1)
subplot(211)

plot(pe,pn,'.b')
hold on
plot(tar_E,tar_N,'xr')
xlabel('pE')
ylabel('pN')
ylim([-25 27000])
xlim([-25 14000])
axis equal
grid on
subplot(212)
hold on
plot(pn,alt,'.r')
xlabel('pN (ft)')
ylabel('Alt (ft)')
xlim([-25 30000])
ylim([0 1500])
grid on


out = pn;