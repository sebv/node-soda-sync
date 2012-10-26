# soda-sync

Note: API change in version 1.0.0, see below.

A synchronous version of [soda](http://github.com/LearnBoost/soda.git), the node client for
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

{browser,sync} = sodaSync.createClient(
  host: "localhost"
  port: 4444
  url: "http://www.google.com"
  browser: "firefox"
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

## upgrade to V1

API was simplified thos are the main changes:

- 1/ require: 

```
sodaSync = require 'soda-sync'
```

- 2/ createClient: 

```
{browser,sync} = sodaSync.createClient(...
```

- 3/ Soda becomes sync
- 4/ SodaCan becomes can (see can section below)
- 5/ mode options have been disabled.

## Sauce Labs example

Remote testing with [Sauce Labs](http://saucelabs.com), works the same as with soda.

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
    pre: -> @timeout 60000 # optional global pre

  it "create client", (done) ->
    {browser} = sodaSync.createClient (
      host: "localhost"
      port: 4444
      url: "http://www.google.com"
      browser: "firefox"
    )   
    done()

  describe "can without pre", ->
    it "should work", can ->
      @session()
      @open '/'
      @getTitle().toLowerCase().should.include 'google'
      @testComplete()

  describe "can with pre", ->
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

sodaSync = require 'soda-sync'

{browser, sync} = soda.createClient(
  host: "localhost"
  port: 4444
  url: "http://www.google.com"
  browser: "firefox"
)   

openRoot = ->
  sodaSync.current().open '/'

sync -> 
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

