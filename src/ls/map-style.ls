angular.module \0media.events
  ..factory \0media.events.map-style, <[]> ++ -> do
    green: [
      {
        "featureType": "water",
        "stylers": [
          { "color": \#18bca8 },
          { "saturation": -35 },
          { "lightness": 68 }
        ]
      },{
        "featureType": "road",
        "elementType": "geometry.stroke",
        "stylers": [
          { "color": \#18bc9c },
          { "saturation": -36 },
          { "lightness": 10 }
        ]
      },{
        "featureType": "road.highway",
        "elementType": "geometry.fill",
        "stylers": [
          { "color": \#18bc9c },
          { "lightness": 65 },
          { "saturation": -22 }
        ]
      },{
      }
    ]



    gray: [
      {
        "featureType": "water",
        "stylers": [
          { "color": \#dddddd }
        ]
      },{
        "featureType": "landscape",
        "stylers": [
          { "color": \#bbbbbb }
        ]
      },{
        "featureType": "road",
        "stylers": [
          { "color": \#999999 },
          { "weight": 0.4 },
          { "visibility": "simplified" }
        ]
      },{
        "featureType": "road",
        "elementType": "labels",
        "stylers": [
          { "visibility": "off" }
        ]
      },{
        "featureType": "poi",
        "stylers": [
          { "color": \#aaaaaa }
        ]
      },{
        "featureType": "administrative",
        "elementType": "geometry",
        "stylers": [
          { "visibility": "on" },
          { "weight": 1.3 },
          { "color": \#444444 }
        ]
      },{
        "featureType": "administrative",
        "elementType": "labels.text.fill",
        "stylers": [
          { "color": \#222222 }
        ]
      },{
        "featureType": "administrative",
        "elementType": "labels.text.stroke",
        "stylers": [
          { "color": \#ffffff }
        ]
      },{
      }
    ]

    default: [
      {
        "featureType": "water",
        "stylers": [
          { "hue": '#1900ff' },
          { "lightness": -86 },
          { "saturation": -80 }
        ]
      },{
        "featureType": "landscape",
        "stylers": [
          { "lightness": -47 },
          { "hue": '#dd3d00' },
          { "saturation": -80 }
        ]
      },{
        "featureType": "poi",
        "stylers": [
          { "saturation": -100 },
          { "lightness": -30 }
        ]
      },{
        "featureType": "road",
        "stylers": [
          { "weight": 0.3 },
          { "saturation": -48 },
          { "lightness": -0 },
          { "hue": '#dd4400' }
        ]
      }
    ]

