soda = require("soda")
{makeSync,sync,current} = require 'make-sync'

buildOptions = 
  mode: 'sync'
  exclude: '*'
  include: soda.commands.concat ['session']

patch = (browser, options) ->
  makeSync browser, buildOptions
  
  # necessary cause soda is doing weird stuff in the 'chain' getter 
  browser.queue = null
  
  _sync = (cb) ->
    if cb?
      sync ->
        current().soda_sync_browser = browser
        cb.apply browser , []
  {
    browser: browser
    sync: _sync
  }

sodaSync =
  # similar to soda
  createClient: (options) ->
    patch (soda.createClient options), options
  createSauceClient: (options) ->
    patch (soda.createSauceClient options), options
    
  # retrieve the browser currently in use
  # useful when writting helpers  
  current: -> current().soda_sync_browser
  

  # careful, below browser is a function so it get evaluated with the rest
  # of the code  
  can: (globalOptions) ->
    (options, cb) ->
      [options,cb] = [null,options] if typeof options is 'function'
      if cb?
        return (done) ->
          globalOptions.pre.apply @, [] if globalOptions?.pre?
          options.pre.apply @, [] if options?.pre?
          sync ->
            current().soda_sync_browser = globalOptions?.with?()
            cb.apply globalOptions?.with?(), []
            done() if done?

module.exports = sodaSync


