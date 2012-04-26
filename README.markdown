# soda-sync

A synchronous Version with a nice api of [soda](http://github.com/LearnBoost/soda.git), the node client for
[Selenium](http://seleniumhq.org), built using [node-fibers](http://github.com/laverdet/node-fibers).


The selenese methods in the 'tested' list below are reliable, most of others methods 
probably work, but as I am testing this as I am using it, they may be some
bugs. If it is the case please open an issue.


## install

```
npm install soda-sync
```

## usage (coffeescript)

Notice the extra 'mode' field in the createClient options.

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

## SodaCan

SodaCan is a wrapper around Soda. It returns a function with an optional 'done' callback, 
called as the last command just before the fiber is closed. 

The example below is using the mocha test framework. Notice that the usual 'done' callback 
is already managed by SodaCan, so can be omited.

Also note that the browser parameter is a function returning the browser so that the browser 
object initialization can be delayed.

```coffeescript
# Assumes that the selenium server is running

should = require 'should'
{soda,Soda,SodaCan} = require 'soda-sync'

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
    it "should work", SodaCan with: (-> browser), -> 
      @session()
      @open '/'
      @getTitle().toLowerCase().should.include 'google'
      @testComplete()
```

## to avoid repeating 'with: browser' or 'with: (-> browser)'

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
{soda,Soda,SodaCan} = require 'soda-sync'

describe "SodaCan", ->
  
  browser = null;
  SodaCan = SodaCan with: -> browser    

  it "create client", (done) ->
    browser = soda.createClient (
      host: "localhost"
      port: 4444
      url: "http://www.google.com"
      browser: "firefox"
      mode: 'sync'
    )   
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

This is useful when writting test helpers.

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

## modes

check [make-sync](http://github.com/sebv/node-make-sync) for more details. 
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
