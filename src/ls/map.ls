angular.module \0media.events
  ..factory \0media.events.map, <[]> ++ -> do
    init: (node, lats, lngs, resize, overlay, config) ->
      map-option = do
        center: new google.maps.LatLng 23.624146, 120.320623
        zoom: parseInt(config.initz or 9)
        minZoom: 1
        maxZoom: 18
        mapTypeId: google.maps.MapTypeId.ROADMAP
        panControl: false
        scaleControl: false
        mapTypeControl: false
        streetViewControl: false
        zoomControlOptions: position: google.maps.ControlPosition.RIGHT_CENTER

      if config.clat and config.clng =>
        map-option.center = new google.maps.LatLng parseFloat(config.clat), parseFloat(config.clng)
      else
        map-bound = new google.maps.LatLngBounds!
        bound-ptrs = [[lats.1, lngs.0] [lats.0, lngs.1]]
        bound-ptrs.map(-> new google.maps.LatLng it.0, it.1)map(->map-bound.extend it)
      simdate = (date) -> date.getYear! + 1900


      map = new google.maps.Map node, map-option
      map.fitBounds map-bound

      google.maps.event.addDomListener window, 'resize', ->
        [w,h] = [$(node).width!, $(node).height!]
        map.fitBounds map-bound
        b = map.getBounds!
        [lat1,lng1] = [b.getNorthEast!.lat!, b.getSouthWest!.lng!]
        [lat2,lng2] = [b.getSouthWest!.lat!, b.getNorthEast!.lng!]
        resize [lat1, lng2], [lat2, lng1]

      _overlay = new google.maps.OverlayView! <<< do
        ll2p: (lat, lng)->
          prj = @getProjection!
          ret = prj.fromLatLngToDivPixel(new google.maps.LatLng lat, lng)
        onAdd: -> overlay.onAdd @, @getPanes!overlayLayer
        draw: -> overlay.draw @, map
      _overlay.setMap map
      return map

