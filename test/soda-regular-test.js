// Generated by CoffeeScript 1.3.1
(function() {
  var Soda, should, soda, _ref;

  should = require('should');

  _ref = require('../lib/soda-sync'), soda = _ref.soda, Soda = _ref.Soda;

  describe("soda-regular", function() {
    var browser;
    browser = null;
    it("create client", function(done) {
      browser = soda.createClient({
        host: "localhost",
        port: 4444,
        url: "http://www.google.com",
        browser: "firefox"
      });
      return done();
    });
    return describe("retrieving google page", function() {
      return it("should work", function(done) {
        return browser.chain.session().open('/').getTitle(function(title) {
          return title.toLowerCase().should.include('google');
        }).end(function(err) {
          return browser.testComplete(function() {
            if (err) {
              throw err;
            }
            return done();
          });
        });
      });
    });
  });

}).call(this);
