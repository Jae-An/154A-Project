C:
cd C:\Program Files\FlightGear

SET FG_ROOT=C:\Program Files\FlightGear\data
SET FG_SCENERY=C:\Program Files\FlightGear\data\Scenery;C:\Program Files\FlightGear\scenery;C:\Program Files\FlightGear\terrasync

.\\bin\fgfs --aircraft=C-2A --fdm=network,localhost,5501,5502,5503 --enable-terrasync --fog-fastest --start-date-lat=2004:06:01:09:00:00 --disable-sound --in-air --enable-freeze --lon=33.9416 --lat=-118.4085 --altitude=100 --heading=0 --offset-azimuth=0
