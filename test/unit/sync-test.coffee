should = require 'should'
sodaSync = require '../../lib/soda-sync'

describe "sync", ->
  {browser,sync} = {}
  it "create client", (done) ->
    {browser,sync} = sodaSync.createClient (
      host: "localhost"
      port: 4444
      url: "http://www.google.com"
      browser: "firefox"
    )
    done()
  
  describe "step by step run", ->
    it "open session", (done) ->
      sync ->
        @session()
        done()
        
    it "opens page", (done) ->
      sync ->
        @open '/'
        done()
    it "types something", (done) ->
      sync ->
        @type 'q', 'Hello World'
        done()
    it "clicks button", (done) ->
      sync ->
        @click 'btnG'
        done()
    it "waits", (done) ->
      sync ->
        @waitForElementPresent 'css=#topstuff' 
        done()
    it "checks title", (done) ->
      sync ->
        @getTitle().toLowerCase().should.include 'hello world'
        done()
    it "finishes test", (done) ->
      sync ->
        @testComplete()
        done()
  describe "retrieving the current browser in an external function", ->
    myOwnGetTitle = -> 
      sodaSync.current().getTitle() 
    it "should work", (done) ->
      sync ->
        @session()
        @open '/'
        myOwnGetTitle().toLowerCase().should.include 'google'
        @testComplete()
        done()  

