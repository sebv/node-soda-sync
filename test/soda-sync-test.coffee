should = require 'should'
{soda,Soda} = require '../lib/soda-sync'

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
    Soda = Soda with:browser         
    done()

  describe "step by step run", ->
    it "open session", (done) ->
      Soda ->
        @session()
        done()
    it "opens page", (done) ->
      Soda ->
        @open '/'
        done()
    it "types something", (done) ->
      Soda ->
        @type 'q', 'Hello World'
        done()
    it "clicks button", (done) ->
      Soda ->
        @click 'btnG'
        done()
    it "waits", (done) ->
      Soda ->
        @waitForElementPresent 'css=#topstuff' 
        done()
    it "checks title", (done) ->
      Soda ->
        @getTitle().toLowerCase().should.include 'hello world'
        done()        
    it "finishes test", (done) ->
      Soda ->
        @testComplete()
        done()

  describe "all at once", ->
    it "should work", (done) ->
      Soda ->
        @session()
        @open '/'
        @type 'q', 'Hello World'
        @click 'btnG'
        @waitForElementPresent 'css=#topstuff' 
        @getTitle().toLowerCase().should.include 'hello world'
        @testComplete()
        done()  
