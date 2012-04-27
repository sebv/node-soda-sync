should = require 'should'
{soda,Soda} = require '../../lib/soda-sync'

describe "soda-regular", ->
  browser = null;
  it "create client", (done) ->
    # async version of the browser
    browser = soda.createClient (
      host: "localhost"
      port: 4444
      url: "http://www.google.com"
      browser: "firefox"
    )   
    done()

  describe "retrieving google page", ->
    it "should work", (done) ->
      browser
        .chain
        .session()
        .open('/')
        .getTitle (title) ->
          title.toLowerCase().should.include 'google'
        .end (err) ->
          browser.testComplete ->
            if(err) then throw err
            done()

