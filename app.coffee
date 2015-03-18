superagent    = require 'superagent'
polygonCenter = require 'geojson-polygon-center'
qs            = require 'qs'

if not location.search
  sourceURL = null
  params = {}
else
  params = qs.parse location.search.slice 1
  sourceURL = params.url or params.source or params.src
  if sourceURL and sourceURL.slice(-1)[0] == '/'
    sourceURL = sourceURL.slice 0, -1

map = new GMaps
  div: '#map'
  lat: 0
  lng: 0
  zoom: 2
  fitZoom: true

if params.type or params.maptype
  # custom map types
  map.addMapType "osm",
    getTileUrl: (coord, zoom) ->
      "http://tile.openstreetmap.org/" + zoom + "/" + coord.x + "/" + coord.y + ".png"
    tileSize: new google.maps.Size(256, 256)
    name: "osm"
    maxZoom: 18
  # ~
  map.setMapTypeId (params.type or params.maptype).toLowerCase()

superagent.get (sourceURL or ''), (err, res) ->
  if err or not res
    return

  pointsToFit = []
  geo = JSON.parse res.text
  for feature in geo.features
    switch feature.geometry.type

      when 'Polygon'
        center = polygonCenter feature.geometry
        pointsToFit = pointsToFit.concat (new google.maps.LatLng pt[1], pt[0] for pt in feature.geometry.coordinates[0])

        infowindow = new google.maps.InfoWindow
          content: infoWindowContent feature

        map.drawPolygon
          paths: feature.geometry.coordinates,
          useGeoJSON: true,
          strokeColor: feature.properties['stroke'] or '#333'
          strokeOpacity: feature.properties['stroke-opacity'] or 1,
          strokeWeight: feature.properties['stroke-width'] or 3,
          fillColor: feature.properties['fill'] or '#333',
          fillOpacity: feature.properties['fill-opacity'] or 0.5,
          click: (e) ->
            map.hideInfoWindows()
            infowindow.setPosition e.latLng
            infowindow.open map.map

        if feature.properties['overlay']
          map.drawOverlay
            lat: center.coordinates[1]
            lng: center.coordinates[0]
            content: '<div class="overlay">' + feature.properties['overlay'] + '</div>'

      when 'Point'
        point = feature.geometry
        pointsToFit.push new google.maps.LatLng point.coordinates[1], point.coordinates[0]
        map.addMarker
          lat: point.coordinates[1]
          lng: point.coordinates[0]
          title: feature.properties['title']
          icon:
            path: google.maps.SymbolPath.CIRCLE
            fillColor: feature.properties['marker-color']
            strokeColor: feature.properties['marker-color']
            fillOpacity: parseFloat(feature.properties['marker-opacity']) or 0.5
            strokeOpacity: parseFloat(feature.properties['marker-opacity']) or 1
            scale: parseFloat(feature.properties['marker-size'] or 1) * 5
          click: (e) ->
            map.hideInfoWindows()
          infoWindow:
            content: infoWindowContent feature

      when 'LineString'
        path = []
        for point in feature.geometry.coordinates
          googlepoint = new google.maps.LatLng point[1], point[0]
          path.push googlepoint
          pointsToFit.push googlepoint

        infowindow = new google.maps.InfoWindow
          content: infoWindowContent feature

        map.drawPolyline
          path: path
          strokeColor: feature.properties['stroke'] or '#333'
          strokeOpacity: parseFloat(feature.properties['stroke-opacity']) or 1,
          strokeWeight: parseFloat(feature.properties['stroke-width']) or 3,
          click: (e) ->
            map.hideInfoWindows()
            infowindow.setPosition e.latLng
            infowindow.open map.map

  map.fitZoom()
  map.fitLatLngBounds(pointsToFit)

infoWindowContent = (feature) ->
  "<div>
    <table class=\"infowindow\">
      #{("<tr>
          <td>#{k}</td>
          <td>#{v}</td>
         </tr>" for k, v of feature.properties).join('')}
    </table>
  </div>"
