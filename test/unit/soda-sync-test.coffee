should = require 'should'
{soda,Soda} = require '../../lib/soda-sync'

describe "soda-sync", ->
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
  describe "step by step run", ->
    it "open session", (done) ->
      Soda with:browser, ->
        @session()
        done()
    it "opens page", (done) ->
      Soda with:browser, ->
        @open '/'
        done()
    it "types something", (done) ->
      Soda with:browser, ->
        @type 'q', 'Hello World'
        done()
    it "clicks button", (done) ->
      Soda with:browser, ->
        @click 'btnG'
        done()
    it "waits", (done) ->
      Soda with:browser, ->
        @waitForElementPresent 'css=#topstuff' 
        done()
    it "checks title", (done) ->
      Soda with:browser, ->
        @getTitle().toLowerCase().should.include 'hello world'
        done()        
    it "finishes test", (done) ->
      Soda with:browser, ->
        @testComplete()
        done()
  describe "all at once, without passing the browser to 'Soda'", ->
    it "should work", (done) ->
      Soda = Soda with:browser         
      
      Soda ->
        @session()
        @open '/'
        @type 'q', 'Hello World'
        @click 'btnG'
        @waitForElementPresent 'css=#topstuff' 
        @getTitle().toLowerCase().should.include 'hello world'
        @testComplete()
        done()  
  describe "retrieving the current browser in an external function", ->
    myOwnGetTitle = -> 
      soda.current().getTitle() 
    it "should work", (done) ->
      Soda = Soda with:browser               
      Soda ->
        @session()
        @open '/'
        myOwnGetTitle().toLowerCase().should.include 'google'
        @testComplete()
        done()  

