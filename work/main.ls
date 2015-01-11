require! <[fs cheerio]>
$ = cheerio.load(fs.read-file-sync \list.html .toString!)
months = <[January February March April May June July August September October November December]>
for li in $("li")
  text = $(li).text!
  flags = $(li).find(".flagicon a")
  name = $(li).find("> a").text!replace /\[.+\]/, ""

  if flags.length == 0 => continue
  country = []
  for flag in flags => country.push $(flag).attr("title")
  date = /^ *(January|February|March|April|May|June|July|August|September|October|November|December)\s*([0-9 –-]+)?,\s*(\d+)/.exec text
  if date => [_,month,day,year,x] = date
  else =>
    date = /^\s*(\d+)\s*(January|February|March|April|May|June|July|August|September|October|November|December)\s*(\d+)/.exec text
    if date => [_,day,month,year,x] = date
  if !year => continue
  month = ( months.indexOf month ) + 1
  dead = /(\d+).+?(dead|killed)/.exec text
  injured = /(\d+).+?(injured|wounded)/.exec text
  dead = if dead => dead.1 else "?"
  injured = if injured => injured.1 else "?"
  #console.log country.join(" "), "[#year/#month/#day]", "#dead killed", "#injured wounded", name
  console.log "#year/#month#{if day => "/"+day else ''}",",", "\"#name\"",",", '""', ",", dead, ",", injured 
