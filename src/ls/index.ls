angular.module \0media.events, <[]>
  ..controller \0media.events.main, <[$scope $interval $timeout $http 0media.events.map 0media.events.map-style]> ++ ($scope,$interval,$timeout,$http,map, map-style) ->
    $scope.style = \default
    mapnode = $('#zm-event .eventmap')
    $scope.dim = {width: 0, height: 0, wtype: 'w-md', htype: 'h-md', timeline-height: 300}
    resize = -> $scope.$apply ->
      [w,h] = [mapnode.width!, mapnode.height!]
      $scope.dim <<< {width: w,height: h}
      $scope.dim.wtype = if w <= 480 => 'w-mc'
        else if w <= 768 => 'w-xs'
        else if w <= 991 => 'w-sm'
        else if w <= 1199 => 'w-md'
        else 'w-lg'
      $scope.dim.htype = if h <=240 => 'h-mc'
        else if h <= 320 => 'h-xs'
        else if h <= 480 => 'h-sm'
        else if h <= 600 => 'h-md'
        else 'h-lg'
      $scope.dim.timeline-height = {'h-mc':120, 'h-xs': 140, 'h-sm': 200, 'h-md': 300, 'h-lg': 300}[$scope.dim.htype]

    overlay-adapter = do
      onAdd: (overlay, root) ->
        bubbles = $('#zm-event .bubbles')0
        bubbles.parentNode.removeChild(bubbles)
        root.appendChild(bubbles)

      draw: (overlay, map) ->
        z = Math.pow(2, map.getZoom! - 6)
        console.log z
        $scope.events.map (event, i) ->
          event <<< overlay.ll2p(event.lat, event.lng){x,y}
          event.rate = z

    $scope.reset = (partial=false) -> 
      $scope.events.top = 5
      $scope.step-count = 0
      $scope.events.map (it, i) -> 
        it <<< {fadeout: 1, opacity: 0.8, size: 0, circle_opacity: 0, bubble: {}, first: false}
        if !partial => it.top = i * 50
        it
    $scope.set-style = (style) ->
      $scope.style = style
      $scope.map.set \styles, map-style[style]
    $scope.play = -> 
      $scope.state = 1
      $scope.dir = 1
    $scope.pause = -> $scope.state = 0
    $scope.speeding = -> $scope.speed = ($scope.speed % 3) + 1
    $scope.step = (dir) -> 
      if dir !=$scope.dir =>
        $scope.events.map (it, i) -> it <<< {bubble: {state: 0}, size: 0, circle_opacity: 0}
      $scope.dir = dir
      
      $scope.state = 2
    $scope.state = 1
    $scope.speed = 3
    $scope.dir = 1
    $scope.loaded = 'loading'
    $scope.initData = ->
      $http do
        url: \https://spreadsheets.google.com/feeds/list/1p0DNKBt4oNfDBgHv4ZXH-vu0bJ_PtxFFXCL7o4O_Cxo/1/public/values?alt=json
        method: \GET
      .success (d) -> 
        data = d.feed.entry.map ->
          date = it['gsx$日期']$t.replace /[年月]/g, '/'
          date = date.replace /[日]/g, ''
          dateFull = new Date(date)
          m = dateFull.getMonth! + 1
          date = (dateFull.getYear! + 1900) + "/" + (if m < 10 => "0" else "") + m
          ret = /(?:(\d+)死)?(?:(\d+)傷)?(?:(\d+)生還)?/.exec it['gsx$死傷']$t
          casualty = {die: parseInt((ret and ret.1) or 0), hurt: parseInt((ret and ret.2) or 0), live: parseInt((ret and ret.3) or 0)}
          casualty.total = casualty.die + casualty.hurt
          casualty.radius = parseInt( Math.sqrt(casualty.total ) ) * 3 + 10
          lat = parseFloat(it['gsx$緯度']$t or 0)
          lng = parseFloat(it['gsx$經度']$t or 0)
          name = (it['gsx$短名']$t or it['gsx$事件']$t)trim!
          loc = new google.maps.LatLng(lat, lng)
          ret = {name, dateFull, casualty, lat, lng, loc, date}
          ret
        data = data.filter -> it.lat and it.lng and it.casualty.total
        lats = data.map(->it.lat)sort!
        lngs = data.map(->it.lng)sort!
        /*
        step = ->
          hit = 0
          chosen = false
          line-h = $scope.dim.timeline-height
          line-h = $('#zm-event .timeline .line').height! * 0.9
          line-h3 = line-h / 3
          line-h133 = line-h * 1.33
          if (data[* - 1].top <= 67 and $scope.dir==1) or (data[0].top >=65 and $scope.dir==-1) => $scope.state = 0
          data.map (it, i) -> 
            if $scope.state == 1 => it.top = it.top - 4 * $scope.dir
            if it.top <= 67 and it.top >= 64 => hit := 1
            if it.top < 65 =>
              it.fadeout = 1 - (65 - it.top) / 20
              if it.fadeout < 0 => it.fadeout = 0
            if it.top > line-h =>
              it.fadeout = 1 - ((it.top - line-h) / line-h3)
            it.opacity = ( line-h133 - it.top ) / line-h133
            it.opacity <?1 >?0
            if it.top < -200 or it.top > line-h =>
              it.bubble.state = 0
              it.circle_opacity = 0
              it.size = 0

            if it.bubble.state == 1 =>
              it.bubble.state = 2
              it.circle_opacity = 0
              it.size = it.casualty.radius * it.rate

            if !chosen and it.top >= 64 => 
              $scope.current = it
              it.first = true
              if it.bubble.state != 2 =>
                it.bubble.state = 1
                it.circle_opacity = 1
                it.size = 0
              chosen := true

            it
          if hit => $timeout step, 910 - ($scope.speed * 300)
          else $timeout step, 40 - ($scope.speed * 10)
        */
        $scope.step-count = 0
        step2 = ->
          if $scope.state => 
            ani-fire = data[$scope.step-count + $scope.dir]
            if ani-fire => 
              ani-fire.circle_opacity = 1
              ani-fire.bubble.state = 1
              ani-fire.size = ani-fire.casualty.radius * ani-fire.rate
            if ani-fire => $scope.current = ani-fire
            ani-hold = data[$scope.step-count]
            if ani-hold => ani-hold.bubble.state = 2

            ani-hide = data[$scope.step-count - $scope.dir]
            if ani-hide => ani-hide.circle_opacity = 0

            $scope.events.top = ($scope.events.top or 5) - 50 * $scope.dir
            if $scope.events.top > 5 =>
              $scope.events.top = 5
              $scope.state = 0
            if $scope.events.top < (5 - ( $scope.events.length - 1 ) * 50) =>
              $scope.events.top = 5 - ( $scope.events.length - 1 ) * 50
              $scope.state = 0

            $scope.step-count += $scope.dir
            $scope.step-count >?= 0
            $scope.step-count <?= ( $scope.events.length - 1)

          if $scope.state == 2 => $scope.state = 0
          $timeout step2, [1600 800 300][$scope.speed - 1]

        #$timeout step, 30
        $timeout step2, 0
        $scope.events = data
        $scope.reset!
        $scope.map = map.init mapnode.0, [lats.0, lats[* - 1]], [lngs.0, lngs[* - 1]], resize, overlay-adapter
        $scope.set-style \default
        $scope.loaded = ''
        setTimeout resize, 0
    $scope.initData!
