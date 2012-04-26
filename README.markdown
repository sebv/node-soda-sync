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


## to avoid repeating 'with: browser' 


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
