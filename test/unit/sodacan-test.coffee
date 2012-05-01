should = require 'should'
{soda,Soda,SodaCan} = require '../../lib/soda-sync'

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

  describe "with soda can, without passing browser", ->
    
    SodaCan = SodaCan with: -> browser    
    
    it "should work", SodaCan -> 
      @session()
      @open '/'
      @getTitle().toLowerCase().should.include 'google'
      @testComplete()

    
