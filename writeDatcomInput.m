function [] = writeDatcomInput(plane)
aoa = 0;
Re = plane.data.aero.Re_cruise;
M = plane.data.aero.v_cruise(1)/1125;

fid = fopen('154A_DATCOM_INPUT.inp','w');
% Flight Configuration

fprintf(fid,' $FLTCON NMACH=1.0, MACH(1)=%.3f,\n',M*1.0);
fprintf(fid,'  NALPHA=%.1f, ALSCHD(1)=',length(aoa));
fprintf(fid,'%.1f,',aoa);
fprintf(fid,'\n  RNNUB(1)=3.539E7$');
% Options
fprintf(fid,'\n $OPTINS ');
fprintf(fid,'SREF=%.2f, ',plane.geo.wing.S);
fprintf(fid,'CBARR=%.2f, ',plane.geo.wing.c);
fprintf(fid,'BLREF=%.2f$',plane.geo.wing.b);
% Synthesis TODO
fprintf(fid,'\n $SYNTHS '); %
fprintf(fid,'XCG=%.2f, ',0.5*plane.geo.body.L); % longitudinal location of CG, (moment reference center)
fprintf(fid,'ZCG=%.1f, ',0.0); % vertical location of CG relative to reference plane
fprintf(fid,'XW=%.2f, ',0.24*plane.geo.body.L); % longitudinal location of theoretical wing apex
fprintf(fid,'ZW=%.2f, ',0.75*plane.geo.body.D); % vertical location of theoretical wing apex relative to reference plane
fprintf(fid,'ALIW=%.1f, ',0.0); % wing root chord incidence angle measured from reference plane
fprintf(fid,'XH=%.2f,',0.9*plane.geo.body.L); % longitudinal location of theoretical horizontal tail apex
fprintf(fid,'\n   ZH=%.1f, ',0.0); % vertical location of theoretical horizontal tail apex relative to reference plane
fprintf(fid,'ALIH=%.1f, ',0.0); % horizontal tail root chord incidence angle measured from reference plane
fprintf(fid,'XV=%.2f, ',0.9*plane.geo.body.L); % longitudinal location of theoretical vertical tail apex
fprintf(fid,'VERTUP=.TRUE.$'); %  =TRUE if vertical panel is above reference plane, =FALSE if vertical panel is below reference plane


% Body
body_length = plane.geo.body.L;
body_r = plane.geo.body.W;
nose_length = body_length*0.15;
nose_x = linspace(0,nose_length,8);
nose_r = body_r.*([0 .2 .4 .65 .8 .9 .95, 1]).*(sin(linspace(0,pi/2,8)).^.2);
tail_length = body_length*0.15;

fprintf(fid,'\n $BODY NX=10.0, BNOSE=2.0, ');
fprintf(fid,'BLN=%.2f, BLA=%.2f,\n',nose_length,tail_length);
fprintf(fid,'   X(1)=');
fprintf(fid,'%.1f, ',[nose_x, nose_length+0.7*body_length, nose_length+0.7*body_length+tail_length]);
fprintf(fid,'\n   R(1)=');
fprintf(fid,'%.1f,',[nose_r, body_r]);
fprintf(fid,'%.1f$',body_r*0.8);

% Wing Planform
fprintf(fid,'\n $WGPLNF ');
fprintf(fid,'CHRDTP=%.2f, ',plane.geo.wing.c* plane.geo.wing.TR); % tip chord
fprintf(fid,'SSPNE=%.2f, ', plane.geo.wing.b/2); % semispan of exposed panel
fprintf(fid,'SSPN=%.2f, ', plane.geo.wing.b/2); % semispan theoretical panel from theoretical root chord
fprintf(fid,'CHRDR=%.2f,\n', plane.geo.wing.c); % root chord
fprintf(fid,'   SAVSI=%.2f, ', plane.geo.wing.sweep*0); % inboard pael sweep angle
fprintf(fid,'CHSTAT=0.25, '); % reference chod station for in/outboard panel sweep angles, fraction of chord
fprintf(fid,'SWAFP=0.0, '); % ???
fprintf(fid,'TWISTA=0.0, '); % twist angle
fprintf(fid,'SSPNDD=0.0,'); % semispan of outboard panel w/ dihedral
fprintf(fid,'\n   DHDADI=0.0, '); % dihedral angle of inboard panel
fprintf(fid,'DHDADO=0.0, '); % dihedral angle of outboard panel
fprintf(fid,'TYPE=1.0$'); % 1: STRAIGHT TAPERED PLANFORM, 2: double delta planform AR<3, 3: cranked planform AR>3

% Wing Characteristics
fprintf(fid,'\nNACA-W-4-6412');
% fprintf(fid,'\n $WGSCHR ');
% fprintf(fid,'TOVC=%.2f, ',plane.geo.wing.ThR);
% fprintf(fid,'DELTAY=%.2f, ',1.3); %TODO, difference between airfoil ordinates at 6% and 15% chord, percent chord
% fprintf(fid,'XOVC=%.2f, ',plane.geo.wing.h_t); % chord location of maximum airfoil thickness


% Vertical Tail Planform
fprintf(fid,'\n $VTPLNF ');
fprintf(fid,'CHRDTP=%.2f, ',plane.geo.v_tail.c* plane.geo.v_tail.TR); % tip chord
fprintf(fid,'SSPNE=%.2f, ', plane.geo.v_tail.b/2); % semispan of exposed panel
fprintf(fid,'SSPN=%.2f, ', plane.geo.v_tail.b/2); % semispan theoretical panel from theoretical root chord
fprintf(fid,'CHRDR=%.2f,\n', plane.geo.v_tail.c); % root chord
fprintf(fid,'   SAVSI=%.2f, ', plane.geo.v_tail.sweep*0); % inboard pael sweep angle
fprintf(fid,'CHSTAT=0.25, '); % reference chod station for in/outboard panel sweep angles, fraction of chord
fprintf(fid,'SWAFP=0.0, '); % ???
fprintf(fid,'TWISTA=0.0, '); % twist angle
fprintf(fid,'SSPNDD=0.0,\n'); % semispan of outboard panel w/ dihedral
fprintf(fid,'   DHDADI=0.0, '); % dihedral angle of inboard panel
fprintf(fid,'DHDADO=0.0, '); % dihedral angle of outboard panel
fprintf(fid,'TYPE=1.0$'); % 1: STRAIGHT TAPERED PLANFORM, 2: double delta planform AR<3, 3: cranked planform AR>3
% Vertical Tail Characteristics
fprintf(fid,'\nNACA-V-4-0009');

% Horizontal Tail Planform
fprintf(fid,'\n $HTPLNF ');
fprintf(fid,'CHRDTP=%.2f, ',plane.geo.h_tail.c* plane.geo.h_tail.TR); % tip chord
fprintf(fid,'SSPNE=%.2f, ', plane.geo.h_tail.b/2); % semispan of exposed panel
fprintf(fid,'SSPN=%.2f, ', plane.geo.h_tail.b/2); % semispan theoretical panel from theoretical root chord
fprintf(fid,'CHRDR=%.2f,\n', plane.geo.h_tail.c); % root chord
fprintf(fid,'   SAVSI=%.2f, ', plane.geo.h_tail.sweep*0); % inboard pael sweep angle
fprintf(fid,'CHSTAT=0.25, '); % reference chod station for in/outboard panel sweep angles, fraction of chord
fprintf(fid,'SWAFP=0.0, '); % ???
fprintf(fid,'TWISTA=0.0, '); % twist angle
fprintf(fid,'SSPNDD=0.0,\n'); % semispan of outboard panel w/ dihedral
fprintf(fid,'   DHDADI=0.0, '); % dihedral angle of inboard panel
fprintf(fid,'DHDADO=0.0, '); % dihedral angle of outboard panel
fprintf(fid,'TYPE=1.0$'); % 1: STRAIGHT TAPERED PLANFORM, 2: double delta planform AR<3, 3: cranked planform AR>3
% Horizontal Tail Characteristics
fprintf(fid,'\nNACA-H-4-6412');

fprintf(fid,'\nDIM FT'); % specify feet and english units
fprintf(fid,'\nDAMP'); % Output Dynamic Stability Derivatives

% fprintf(fid,'\nBUILD');
fprintf(fid,'\nCASEID 154A PLANE, CASE 1');
% fprintf(fid,'\nSAVE');
fprintf(fid,'\nDUMP DYN');
fprintf(fid,'\nNEXT CASE');
% fprintf(fid,'\nCASEID 154A PLANE DAMP, CASE 2');
% fprintf(fid,'\nDUMP FCM');
% fprintf(fid,'\nNEXT CASE');

fclose(fid);
end