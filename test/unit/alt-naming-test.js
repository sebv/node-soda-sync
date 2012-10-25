// Generated by CoffeeScript 1.3.3
(function() {
  var can, should, soda, someText, sync, _ref;

  should = require('should');

  _ref = require('../../lib/soda-sync'), soda = _ref.soda, sync = _ref.sync, can = _ref.can;

  someText = null;

  describe("JSLint compliant naming.", function() {
    var browser;
    browser = null;
    it("create client", function(done) {
      browser = soda.createClient({
        host: "localhost",
        port: 4444,
        url: "http://www.google.com",
        browser: "firefox",
        mode: 'sync'
      });
      return done();
    });
    describe("with sync", function() {
      return it("should work", function(done) {
        return sync({
          "with": browser
        }, function() {
          this.session();
          this.open('/');
          this.getTitle().toLowerCase().should.include('google');
          this.testComplete();
          return done();
        });
      });
    });
    return describe("with can", function() {
      return it("should work", can({
        "with": function() {
          return browser;
        },
        pre: function() {
          this.timeout(30000);
          return someText = 'Test1';
        }
      }, function() {
        someText.should.equal('Test1');
        this.session();
        this.open('/');
        this.getTitle().toLowerCase().should.include('google');
        return this.testComplete();
      }));
    });
  });

}).call(this);