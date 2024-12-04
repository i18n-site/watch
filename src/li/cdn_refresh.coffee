#!/usr/bin/env coffee
> pg

< DURATION = 60

< (connectionString) =>
  c = new pg.Client {
    connectionString
  }

  try
    # p = new Promise (resolve, reject)=>
    #   c.on 'error', reject
    #   return
    await c.connect()
    {rows} = await c.query(
      "SELECT name,ts FROM cdn.vps_not_refresh()"
    )
    if rows.length
      throw rows.map ([name, ts])=>
        name + ' 上次更新 ' + new Date(ts).toLocaleString().slice(0,19)
    return
  finally
    await c.end()
  return

