// Generated by CoffeeScript 1.3.3
(function() {
  var should, sodaSync, someText;

  should = require('should');

  sodaSync = require('../../lib/soda-sync');

  someText = null;

  describe("can", function() {
    describe("no pre", function() {
      var browser, can;
      browser = null;
      can = sodaSync.can({
        "with": function() {
          return browser;
        }
      });
      it("create client", function(done) {
        browser = sodaSync.createClient({
          host: "localhost",
          port: 4444,
          url: "http://www.google.com",
          browser: "firefox"
        }).browser;
        return done();
      });
      return describe("with soda can", function() {
        return it("should work", can(function() {
          this.session();
          this.open('/');
          this.getTitle().toLowerCase().should.include('google');
          return this.testComplete();
        }));
      });
    });
    return describe("with pre", function() {
      var browser, can;
      browser = null;
      can = sodaSync.can({
        "with": function() {
          return browser;
        },
        pre: function() {
          return this.timeout(30000);
        }
      });
      it("create client", function(done) {
        browser = sodaSync.createClient({
          host: "localhost",
          port: 4444,
          url: "http://www.google.com",
          browser: "firefox"
        }).browser;
        return done();
      });
      return describe("with soda can", function() {
        return it("should work", can({
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
  });

}).call(this);
