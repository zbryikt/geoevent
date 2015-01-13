require! <[fs cheerio request bluebird]>

prequest = (config) -> new bluebird (res, rej) ->
  (e,r,b) <- request config, _
  if e or !b => return rej {e,r,b}
  return res {e,r,b}

degrule = /(\d+)°(\d+)′([0-9.]+)″([NEWS])/
$ = cheerio.load(fs.read-file-sync \list.html .toString!)
months = <[January February March April May June July August September October November December]>
parsed = []
count = 0
for li in $("li")
  text = $(li).text!
  flags = $(li).find(".flagicon a")
  if flags.length == 0 => continue
  country = []
  for flag in flags => country.push $(flag).attr("title")
  $(li).find("span").remove!
  name = $(li).find("> a").text!replace /\[.+\]/, ""
  href = $($(li).find("> a[href]").0).attr("href")
  date = /^ *(January|February|March|April|May|June|July|August|September|October|November|December)\s*([0-9 –-]+)?,\s*(\d+)/.exec text
  if date => [_,month,day,year,x] = date
  else =>
    date = /^\s*(\d+)\s*(January|February|March|April|May|June|July|August|September|October|November|December)\s*(\d+)/.exec text
    if date => [_,day,month,year,x] = date
  if !year => continue
  #if count >= 3 => break
  count++
  #console.log name, href
  month = ( months.indexOf month ) + 1
  dead = /(\d+)\D+?(dead|killed)/.exec text
  injured = /(\d+)\D+?(injured|wounded)/.exec text
  dead = if dead => dead.1 else "?"
  injured = if injured => injured.1 else "?"
  date = new Date(year, month, day or 1)
  data = {date, year, month, day, name, dead, injured, country, href}
  parsed.push data
  #console.log "#year/#month#{if day => "/"+day else ''}",",", "\"#name\"",",", '""', ",", dead, ",", injured, ',"","","",',country.join "/"
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

tasks = for p in parsed => handler p
bluebird.all(tasks).then -> 
  #console.log parsed
  for item in parsed =>
    {year,month,day,name,dead,injured,lat,lng,country} = item
    console.log "#year/#month#{if day => "/"+day else ''}",",", "\"#name\"",",", '""', ",", dead, ",", injured, ",",lat,",",lng,',"",',country.join "/"
