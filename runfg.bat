C:
cd C:\Program Files\FlightGear

SET FG_ROOT=C:\Program Files\FlightGear\data
.\\bin\fgfs --aircraft=C-2A --fdm=network,localhost,5501,5502,5503 --fog-fastest --disable-clouds --start-date-lat=2004:06:01:09:00:00 --disable-sound --in-air --enable-freeze --airport=KLAX --runway=24L --altitude=200 --heading=113 --offset-distance=0 --offset-azimuth=0 --enable-terrasync --prop:/sim/rendering/shaders/quality-level=0
