function [] = runDatcom(plane)

writeDatcomInput(plane);
[~,~] = system('datcom.exe < DATINTXT.txt');
aero = datcomimport('datcom.out',true,0);


end