should = require 'should'
{soda,sync,can} = require '../../lib/soda-sync'

someText = null

describe "JSLint compliant naming.", ->
  
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

  describe "with sync", ->
    it "should work", (done) ->
      sync with:browser, ->
        @session()
        @open '/'
        @getTitle().toLowerCase().should.include 'google'
        @testComplete()
        done()

  describe "with can", ->
    it "should work", can
      with: -> 
        browser
      pre: ->
        @timeout 30000
        someText = 'Test1'
    , -> 
      someText.should.equal 'Test1' 
      @session()
      @open '/'
      @getTitle().toLowerCase().should.include 'google'
      @testComplete()

    
