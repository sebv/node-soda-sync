soda = require("soda")
{MakeSync,Sync} = require 'make-sync'

buildOptions = (mode) ->
  mode = 'sync' if not mode?
  {
    mode: mode
    exclude: '*'
    include: soda.commands.concat ['session']
  }

sodaSync =
  # similar to soda
  createClient: (options) ->
    browser = soda.createClient options
    if(options?.mode?)
      MakeSync browser, (buildOptions options.mode) 
      browser.queue = null  # necessary cause soda is doing weird stuff
    browser                 # in the 'chain' getter 
  
  # retrieve the browser currently in use
  # useful when writting helpers  
  current: -> Fiber.current.soda_sync_browser
  
cleanArgs = (browser, cb) ->    
  [browser,cb] = [null,browser] if typeof browser is 'function' 
  browser = browser?.with if browser?.with?
  [browser,cb]

Soda = (browser, cb) ->
  [browser,cb] = cleanArgs browser, cb
  if cb? then Sync ->
    Fiber.current.soda_sync_browser = browser
    cb.apply browser, []
  if browser
    # returning an identical function with context(browser) preconfigured 
    (browser2, cb2) ->
      [browser2,cb2] = cleanArgs browser2, cb2
      browser2 = browser if not browser2?
      Soda with:browser2, cb2      

# careful, below browser is a function so it get evaluated with the rest
# of the code  
SodaCan = (browser, cb) ->
  [browser,cb] = cleanArgs browser, cb
  if cb?
    return (done) ->
      Sync ->
        Fiber.current.soda_sync_browser = browser?()
        cb.apply browser?(), []
        done() if done?
  if browser
    # returning an identical function with context(browser) preconfigured 
    return (browser2, cb2) ->
      [browser2,cb2] = cleanArgs browser2, cb2
      browser2 = browser if not browser2?
      SodaCan with:browser2, cb2      

exports.Soda = Soda
exports.SodaCan = SodaCan
exports.soda = sodaSync
