#!/usr/bin/env coffee

> koa:Koa
  ./main.js
  ./STATUS.js

main()

KOA = new Koa

KOA.use (ctx)=>
  li = []

  for [name, map] from STATUS.entries()
    # console.log {name, map}
    li.push t = [
      name
    ]
    for [item, status] from map.entries()
      t.push [
        item
        status
      ]

  ctx.body = JSON.stringify li
  return


PORT = process.env.PORT || 3235

console.log 'listen on http://0.0.0.0:'+PORT
KOA.listen PORT
