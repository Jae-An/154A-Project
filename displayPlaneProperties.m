function [] = displayPlaneProperties(plane)
fprintf('Rate of Climb: %.2f fpm',plane.data.performance.ROC*60)
fprintf('\nRange: %.2f miles',plane.data.performance.R/5280)


fprintf('\nGeometry:')
fprintf('\n\t Wing:')
fprintf('\n\t\t Area: %.2f ft2',plane.geo.wing.S)
fprintf('\t\t Span: %.2f ft',plane.geo.wing.b)
fprintf('\t\t Chord: %.2f ft2',plane.geo.wing.c)

fprintf('\n\t Horizontal Tail:')
fprintf('\n\t\t Area: %.2f ft2',plane.geo.h_tail.S)
fprintf('\t\t Span: %.2f ft',plane.geo.h_tail.b)
fprintf('\t\t Chord: %.2f ft2',plane.geo.h_tail.c)

fprintf('\n\t Vertical Tail:')
fprintf('\n\t\t Area: %.2f ft2',plane.geo.v_tail.S)
fprintf('\t\t Span: %.2f ft',plane.geo.v_tail.b)
fprintf('\t\t Chord: %.2f ft2',plane.geo.v_tail.c)

fprintf('\n\t Body:')
fprintf('\n\t\t Diameter: %.2f ft2',plane.geo.body.D)
fprintf('\t\t Length: %.2f ft',plane.geo.body.L)

fprintf('\n')
end