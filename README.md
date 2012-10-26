# soda-sync

A synchronous Version with a nice api of [soda](http://github.com/LearnBoost/soda.git), the node client for
[Selenium](http://seleniumhq.org), built using [node-fibers](http://github.com/laverdet/node-fibers).

Remote testing with [Sauce Labs](http://saucelabs.com) also works.

## install

```
npm install soda-sync
```

## usage (coffeescript)


```coffeescript
# Assumes that the selenium server is running

sodaSync = require 'soda-sync'

browser = sodaSync.createClient(
  host: "localhost"
  port: 4444
  url: "http://www.google.com"
  browser: "firefox"
  mode: 'sync'
)   

sync ->
  @session()
  @open '/'
  @type 'q', 'Hello World'
  @click 'btnG'
  @waitForElementPresent 'css=#topstuff' 
  title = @getTitle()
  console.log "Got title=", title        
  @testComplete()
```

All the methods from [soda](http://github.com/LearnBoost/soda.git) / 
[Selenium](http://seleniumhq.org) are available. 

The browser methods must be called within a sync block which holds the fiber environment. 
The sync block context is set to the Soda browser so that the browser methods may be 
accessed using '@'.

## Sauce Labs example

Remote testing with [Sauce Labs](http://saucelabs.com), works the same as with soda,
just add the mode field to the options.

```coffeescript
sodaSync = require 'soda-sync'

# configure your sauce account here
username = '<USERNAME>'
access_key = '<ACCESS-KEY>'

{browser,sync} = sodaSync.createSauceClient(
  url: "http://www.google.com"
  username: username
  "access-key": access_key
  os: "Linux"
  browser: "firefox"
  "browser-version": "3."
  "max-duration": 300
  name: "soda-sync sauce example"
  mode: 'sync'
)
browser.on 'command', (cmd, args) ->
  console.log ' \x1b[33m%s\x1b[0m: %s', cmd, args.join(', ')   

sync ->
  @session()
  @open '/'
  @type 'q', 'Hello World'
  @click 'btnG'
  @waitForElementPresent 'css=#topstuff'
  console.log @getTitle()
  browser.setContext "sauce:job-info={\"passed\": true}"
  @testComplete()
  console.log  browser.jobUrl
```

## Soda can

can is a wrapper around Soda, making it easy to integrate with the usual
test frameworks.

The example below is using the mocha test framework. The usual 'done' callback is managed within the Soda can.

The 'with' parameter is a function returning the browser evaluated each time the block is opened.

'pre' methoda may also be specified globally or locally. It is called before the Soda block starts, in the original 
context (In Mocha, it can be used to configure timeouts).

```coffeescript
# Assumes that the selenium server is running

should = require 'should'
sodaSync = require 'soda-sync'

describe "can", ->
  {browser} = null;
  can = sodaSync.can
    with: -> browser
    pre: -> @timeout 60000 # global pre

  it "create client", (done) ->
    {browser} = sodaSync.createClient (
      host: "localhost"
      port: 4444
      url: "http://www.google.com"
      browser: "firefox"
      mode: 'sync'
    )   
    done()

  describe "with soda can", ->
    it "should work", can 
      pre: -> 
        @timeout 30000 # local pre
    , -> 
      @session()
      @open '/'
      @getTitle().toLowerCase().should.include 'google'
      @testComplete()
```

## to retrieve the browser currently in use

The current browser is automatically stored in the Fiber context.
It can be retrieved with the soda.current() function. 

This is useful when writing test helpers.

```coffeescript
# Assumes that the selenium server is running

{soda,Soda} = require 'soda-sync'

browser = soda.createClient(
  host: "localhost"
  port: 4444
  url: "http://www.google.com"
  browser: "firefox"
  mode: 'sync'
)   

openRoot = ->
  soda.current().open '/'

Soda = Soda with:browser

Soda -> 
  @session()
  openRoot()  
  @testComplete()
```

## Selenium server

Download the Selenium server [here](http://seleniumhq.org/download/).

To start the server:

```
java -jar selenium-server.jar
```

