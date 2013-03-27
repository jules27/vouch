initialize = () ->
  mapDiv  = document.getElementById('map-canvas')

  latlong = new google.maps.LatLng(LAT, LONG)
  options =
    {
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      center: latlong,
      zoom: 15
    }

  name = document.getElementById('business_title').innerHTML

  map = new google.maps.Map(mapDiv, options)
  marker = new google.maps.Marker({
              map: map,
              position: latlong,
              title: name
            })
  return

google.maps.event.addDomListener(window, 'load', initialize)
