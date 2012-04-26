soda = require("soda")
{MakeSync,Sync} = require 'make-sync'

buildOptions = (mode) ->
  mode = 'sync' if not mode?
  {
    mode: mode
    exclude: ['enqueue','command','emit','commandPath']
  }

sodaSync =
  createClient: (options) ->
    browser = soda.createClient options
    if(options?.mode?)
      MakeSync browser, (buildOptions options.mode) 
      browser.queue = null  # necessary cause soda is doing weird stuff
      browser               # in the 'chain' getter 
  
cleanArgs = (ctx, cb) ->    
  [ctx,cb] = [null,ctx] if typeof ctx is 'function' 
  ctx = ctx?.with if ctx?.with?
  [ctx,cb]

Soda = (ctx, cb) ->
  [ctx,cb] = cleanArgs ctx, cb
  if cb? then Sync ->
    cb.apply ctx, []
  if ctx
    # we return another function preconfigured for this browser
    (ctx2, cb2) ->
      [ctx2,cb2] = cleanArgs ctx2, cb2
      ctx2 = ctx if not ctx2?
      Soda ctx2, cb2      

exports.Soda = Soda
exports.soda = sodaSync
