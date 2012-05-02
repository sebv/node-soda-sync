should = require 'should'
{soda,Soda,SodaCan} = require '../../lib/soda-sync'

someText = null

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
        someText = 'Test1'
    , -> 
      someText.should.equal 'Test1' 
      @session()
      @open '/'
      @getTitle().toLowerCase().should.include 'google'
      @testComplete()

  describe "with soda can, without passing browser", ->
    
    SodaCan = SodaCan 
      with: -> 
        browser    
      pre: ->
        @timeout 30000
        someText = 'Test2'
    
    it "should work", SodaCan -> 
      someText.should.equal 'Test2' 
      @session()
      @open '/'
      @getTitle().toLowerCase().should.include 'google'
      @testComplete()

    
