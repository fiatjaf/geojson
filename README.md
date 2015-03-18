A Google Maps GeoJSON renderer running on your browser (but with URLs you can share!).

### Examples!

* [Linestrings and markers with properties](http://fiatjaf.alhur.es/geojson/?type=hybrid&url=https://gist.githubusercontent.com/fiatjaf/5a5b49d4e3b9306cb1e8/raw/a2428d67a2d680ee0810c732f4cb2ef7a45e1e7d/map.geojson/), from [this gist](https://gist.github.com/fiatjaf/5a5b49d4e3b9306cb1e8/)
* [Polygons with overlays](http://fiatjaf.alhur.es/geojson/?url=https://gist.githubusercontent.com/fiatjaf/f3fb3621dbeb38717431/raw/dacbded21836ad376a944964ba6295fa4d345f4f/map.geojson/), from [this gist](https://gist.github.com/fiatjaf/f3fb3621dbeb38717431/)
* [Polygon with a point on a terrain map](http://fiatjaf.alhur.es/geojson/?type=terrain&src=http://rawgit.com/fiatjaf/maps/master/batata.geojson/), from [this file](https://github.com/fiatjaf/maps/blob/master/batata.geojson)

### Documentation!

It takes two URL parameters (querystring parameters):

| Parameter | What |
| ----------|:-------------:| -----:|
| url       | the URL of your raw GeoJSON file (like `https://gist.githubusercontent.com/fiatjaf/5a5b49d4e3b9306cb1e8/raw/a2428d67a2d680ee0810c732f4cb2ef7a45e1e7d/map.geojson`) |
| type      | the type of the underlying map (possible values are `roadmap`, `hybrid`, `satellite`, `terrain` and `osm`, ) |

This tool mostly do not use the [Google Maps simple support for raw GeoJSON](https://developers.google.com/maps/documentation/javascript/examples/layer-data-simple), instead it does its conversions from GeoJSON types to Google Maps objects mostly manually (mostly, because the hard work is done by [gmaps](http://hpneo.github.io/gmaps/)), so the results are better (and resemble the output of other map renderers out there, based on Leaflet). However, there can be features missing for a while.

Currently we accept GeoJSON with a `FeatureCollection`, like what is generated at [geojson.io](http://geojson.io). The [styling properties](https://github.com/mapbox/simplestyle-spec/tree/master/1.1.0) supported there are also mostly supported here (a notable missing feature are marker icons).

However, we support an `overlay` attribute that, when added to a `Polygon`, shows its value over the polygon constantly.
