# soda-sync

A synchronous Version with a nice api of [soda](http://github.com/LearnBoost/soda.git), the node client for
[Selenium](http://seleniumhq.org), built using [node-fibers](http://github.com/laverdet/node-fibers).

Remote testing with [Sauce Labs](http://saucelabs.com) also works.

## install

```
npm install soda-sync
```

## usage (coffeescript)

When calling createClient to get a new browser object,  add an extra 'mode' 
field need to be passed in the options.

All the methods from [soda](http://github.com/LearnBoost/soda.git) / 
[Selenium](http://seleniumhq.org) are available. 


In sync mode, the browser function must to be run within a Soda block. This 
block holds the fiber environment. The Soda block context is set to the browser, 
so that the browser methods may be accessed using '@'.

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

Soda with:browser, ->
  @session()
  @open '/'
  @type 'q', 'Hello World'
  @click 'btnG'
  @waitForElementPresent 'css=#topstuff' 
  title = @getTitle()
  console.log "Got title=", title        
  @testComplete()
```
## Sauce Labs example

Remote testing with [Sauce Labs](http://saucelabs.com), works the same as with soda,
just add the mode field to the options.

```coffeescript
{soda,Soda} = require 'soda-sync'

# configure your sauce account here
username = '<USERNAME>'
access_key = '<ACCESS-KEY>'

browser = soda.createSauceClient(
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

Soda with:browser, ->
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


## SodaCan

SodaCan is a wrapper around Soda. It returns a function with a callback arguments, called last, 
after other commands have been executed.

The example below is using the mocha test framework. The usual 'done' callback is managed within SodaCan.

The 'use' parameter is a function returning the browser evaluated each time the block is opened.

A 'pre' method may also be specified. It is called before the Soda block starts, in the original 
context (In Mocha, it can be used to configure timeouts).

```coffeescript
# Assumes that the selenium server is running

should = require 'should'
{soda,SodaCan} = require 'soda-sync'

describe "SodaCan", ->
  browser = null;
  
  it "create client", (done) ->
    browser = soda.createClient (
      host: "localhost"
      port: 4444
      url: "http://www.google.com"
      browser: "firefox"
      mode: 'sync'
    )   
    done()

  describe "with soda can, passing browser", ->
    it "should work", SodaCan 
      with: -> 
        browser
      pre: -> 
        @timeout 30000
    , -> 
      @session()
      @open '/'
      @getTitle().toLowerCase().should.include 'google'
      @testComplete()
```


## a slightly leaner syntax

When there is a browser parameter and no callback, Soda or SodaCan
returns a version of itself with a browser default added.

Soda sample below:
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

Soda = Soda with:browser

Soda -> 
  @session()
  @open '/'
  @testComplete()
```

SodaCan sample below, using the mocha test framework:
```coffeescript
# Assumes that the selenium server is running

should = require 'should'
{soda,SodaCan} = require 'soda-sync'

describe "SodaCan", ->
  
  browser = null;
  SodaCan = SodaCan 
    with: 
      -> browser    
    pre: 
      -> @timeout 30000    

  it "create client", (done) ->
    browser = soda.createClient
      host: "localhost"
      port: 4444
      url: "http://www.google.com"
      browser: "firefox"
      mode: 'sync'
    done()

  describe "with soda can, without passing browser", ->
    it "should work", SodaCan -> 
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
## alternate naming (JSLint Compliant)

```coffeescript
{soda,sync,can} = require 'soda-sync'
```

- sync is the same as Soda
- can is the same as SodaCan 

## modes

check [make-sync](http://github.com/sebv/node-make-sync/blob/master/README.markdown#modes) for more details. 
Probably best to use the 'sync' mode.

```coffeescript
mode: 'sync'
mode: 'async'

mode: ['mixed']
mode: ['mixed','args']

mode: ['mixed','fibers']
```


## Selenium server

Download the Selenium server [here](http://seleniumhq.org/download/).

To start the server:

```
java -jar selenium-server.jar
```


## tested

soda
*  createClient
  
browser
*  session
*  open
*  type
*  click
*  waitForElementPresent
*  getTitle
*  testComplete
