// Generated by CoffeeScript 1.4.0
(function() {
  var config, should, sodaSync;

  should = require('should');

  sodaSync = require('../../lib/soda-sync');

  config = null;

  try {
    config = require('./config');
  } catch (err) {

  }

  describe("sauce integration", function() {
    var browser, sync, _ref;
    _ref = {}, browser = _ref.browser, sync = _ref.sync;
    it("create client", function(done) {
      var _ref1;
      should.exist(config, 'you need to configure your sauce username and access-key ' + 'in the file config.coffee.', (_ref1 = sodaSync.createSauceClient({
        url: "http://www.google.com",
        username: config.saucelabs.username,
        "access-key": config.saucelabs['access-key'],
        os: "Linux",
        browser: "firefox",
        "browser-version": "3.",
        "max-duration": 300,
        name: "soda-sync sauce test"
      }), browser = _ref1.browser, sync = _ref1.sync, _ref1));
      browser.on('command', function(cmd, args) {
        return console.log(' \x1b[33m%s\x1b[0m: %s', cmd, args.join(', '));
      });
      return done();
    });
    return describe("all at once, without passing the browser to 'Soda'", function() {
      return it("should work", function(done) {
        this.timeout(90000);
        return sync(function() {
          this.session();
          this.open('/');
          this.type('q', 'Hello World');
          this.click('btnG');
          this.waitForElementPresent('css=#topstuff');
          this.getTitle().toLowerCase().should.include('hello world');
          browser.setContext("sauce:job-info={\"passed\": true}");
          this.testComplete();
          browser.jobUrl.should.include("jobs");
          return done();
        });
      });
    });
  });

}).call(this);
