should = require 'should'
sodaSync = require '../../lib/soda-sync'

someText = null

describe "can", ->

  describe "no pre", ->

    browser = null
    can = sodaSync.can
      with: -> browser

    it "create client", (done) ->
      {browser} = sodaSync.createClient (
        host: "localhost"
        port: 4444
        url: "http://www.google.com"
        browser: "firefox"
      )
      done()

    describe "with soda can", ->
      it "should work", can ->
        @session()
        @open '/'
        @getTitle().toLowerCase().should.include 'google'
        @testComplete()
        
  describe "with pre", ->

    browser = null
    can = sodaSync.can
      with: -> browser
      pre: -> @timeout 30000

    it "create client", (done) ->
      {browser} = sodaSync.createClient (
        host: "localhost"
        port: 4444
        url: "http://www.google.com"
        browser: "firefox"
      )
      done()

    describe "with soda can", ->
      it "should work", can
        pre: ->
          @timeout 30000
          someText = 'Test1'
      , ->
        someText.should.equal 'Test1'
        @session()
        @open '/'
        @getTitle().toLowerCase().should.include 'google'
        @testComplete()
    
