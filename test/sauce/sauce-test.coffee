# before running this test
# 1/ copy  config-sample.coffee into config.coffee
# 2/ configure the username+access key in this file

should = require 'should'
{soda,Soda} = require '../../lib/soda-sync'
config = null
try config = require './config' catch err 

describe "sauce integration", ->
  
  browser = null;
  it "create client", (done) ->    
    should.exist config,
      'you need to configure your sauce username and access-key '\
      + 'in the file config.coffee.'
    browser = soda.createSauceClient(
      url: "http://www.google.com"
      username: config.saucelabs.username
      "access-key": config.saucelabs['access-key']
      os: "Linux"
      browser: "firefox"
      "browser-version": "3."
      "max-duration": 300
      name: "soda-sync sauce test"
      mode: 'sync'
    )
    browser.on 'command', (cmd, args) ->
      console.log ' \x1b[33m%s\x1b[0m: %s', cmd, args.join(', ')   
    done()
  describe "all at once, without passing the browser to 'Soda'", ->
    it "should work", (done) ->
      @timeout 90000      
      Soda with:browser, ->
        this.session()
        this.open '/'
        this.type 'q', 'Hello World'
        this.click 'btnG'
        this.waitForElementPresent 'css=#topstuff'
        this.getTitle().toLowerCase().should.include 'hello world'
        browser.setContext "sauce:job-info={\"passed\": true}"
        @testComplete()
        browser.jobUrl.should.include "jobs"
        done()


