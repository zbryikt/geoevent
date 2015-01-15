require! <[fs cheerio request bluebird]>

prequest = (config) -> new bluebird (res, rej) ->
  (e,r,b) <- request config, _
  if e or !b => return rej {e,r,b}
  return res {e,r,b}

degrule = /(\d+)°(\d+)′([0-9.]+)″([NEWS])/
$ = cheerio.load(fs.read-file-sync \air.html .toString!)
months = <[January February March April May June July August September October November December]>
parsed = []
#console.log "parsing list..."
for h3 in $('#mw-content-text h3')
  year = $(h3).find('.mw-headline').text!trim!
  list =  $(h3).next!find("li")
  for li in list
    li = $(li)
    content = li.text!
    link = $(li.find("a").0)
    href = link.attr("href")
    name = link.text!
    date = /^ *(January|February|March|April|May|June|July|August|September|October|November|December)\s*([0-9]+)?/.exec content
    if date => [_,month,day,x] = date
    else =>
      date = /^\s*(\d+)\s*(January|February|March|April|May|June|July|August|September|October|November|December)/.exec content
      if date => [_,day,month,x] = date
    month = months.indexOf(month) + 1
    #console.log "* #year/#month/#day -- #name - #href "
    date = new Date(year, month, day or 1)
    data = {date, year, month, day, name, href}
    parsed.push data

handler = (obj) ->
  prequest({url: "http://en.wikipedia.org#{p.href}",method: \GET})
  .then ({e,r,b}) ->
    $ = cheerio.load b
    lat = $($(".latitude").0).text!
    lng = $($(".longitude").0).text!
    if !lat or !lng =>
      obj <<< {lat: 0, lng: 0}
      return
    [lat,lng] = [lat,lng].map -> degrule.exec it
    if !lat or !lng => return
    obj.lat = parseInt(lat.1) + (parseInt(lat.2) / 60) + (parseInt(lat.3) / 3600) 
    obj.lng = parseInt(lng.1) + (parseInt(lng.2) / 60) + (parseInt(lng.3) / 3600) 
    if "SW".indexOf(lat.4)>=0 => obj.lat = -obj.lat
    if "SW".indexOf(lng.4)>=0 => obj.lng = -obj.lng
    return
  , ({e,r,b}) ->

tasks = for p in parsed => handler p
bluebird.all(tasks).then -> 
  for item in parsed =>
    {year,month,day,name,dead,injured,lat,lng} = item
    console.log "#year/#month#{if day => "/"+day else ''},'#name','','','',#lat,#lng,''"

