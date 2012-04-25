# soda-sync

Synchronous Version of the [soda](http://github.com/LearnBoost/soda.git) 
selenium client.

The Selenium methods in the 'tested' list below are reliable, most of others methods 
probably work, but as I am testing this as I am using it, they may be some
bugs. If it the case please open an issue.


## install

```
npm install soda-sync
```


## usage (coffeescript)


```coffeescript
{soda,Soda} = require '../lib/soda-sync'

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
{soda,Soda} = require '../lib/soda-sync'

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

Soda ->
  @type 'q', 'Hello World'
  @click 'btnG'

Soda ->
  @waitForElementPresent 'css=#topstuff' 
  title = @getTitle()
  console.log "Got title=", title        

Soda ->
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
