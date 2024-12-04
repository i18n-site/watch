#!/usr/bin/env coffee

> path > dirname join
  fs > readdirSync
  @3-/yml/Yml.js
  @3-/sleep
  heap-js > Heap
  ./STATUS.js:@ > setErr setOk

PWD = import.meta.dirname
ROOT = dirname PWD
CONF = join dirname(ROOT), 'conf'
CONF_WATCH = Yml join CONF, 'watch'
SRC_LI = join PWD, 'li'

run = (timeout, func, name, item, conf)=>
  retry = 0
  timer = setTimeout(
    =>
      setErr(name, item, 'timeout')
    timeout*1e3
  )
  try
    loop
      try
        await func conf
        setOk(name, item)
        return
      catch err
        setErr(name, item, err)
        if ++retry > 3
          return
  finally
    clearTimeout timer
  return

export default =>
  heap = new Heap (a,b)=>a[0]-b[0]
  for fname from readdirSync SRC_LI
    if fname.endsWith '.js'
      jsfp = join(SRC_LI, fname)
      name = fname.slice(0,-3)
      {
        default: func
        DURATION
      } = (await import(jsfp))

      duration = Math.max 1, DURATION

      map = new Map
      STATUS.set name, map

      for [item, conf] from Object.entries CONF_WATCH[name]
        map.set item, 0
        heap.push [
          0
          duration
          func
          name
          item
          conf
        ]

  offset = 0
  sleep_time = 1
  loop
    console.log '\n'+(new Date).toLocaleString()+' 已经运行 ' + Math.round(offset*10/6)/100 + ' 分钟'
    loop
      o = heap.pop()
      diff = o[0] - offset
      can_run = diff <= 0
      if can_run
        o[0] = offset+o[1]
        run ...o.slice(1)
      heap.push o
      if not can_run
        sleep_time = diff
        break
    offset += sleep_time
    await sleep sleep_time*1e3

  return
# < default main = =>
#   cd ROOT
#   await $"ls #{ROOT}"
#   await $'pwd'
#   return
#
# if process.argv[1] == decodeURI (new URL(import.meta.url)).pathname
#   await main()
#   process.exit()
#
