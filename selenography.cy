// selenography - unit testing for iPhone apps/extensions via Cycript

// Include NSLog.
NSLog_ = dlsym(RTLD_DEFAULT, "NSLog")
NSLog = function() { var types = 'v', args = [], count = arguments.length; for (var i = 0; i != count; ++i) { types += '@'; args.push(arguments[i]); } new Functor(NSLog_, types).apply(null, args); }

var passes = 0;
var fails = 0;

// => LOGGERS
// Lets you output test results in various ways
var NSLogLogger = new function InternalNSLogLogger() {
  this.log = function(str) { NSLog(str); }
  this.terminate = function(c) {}
}

var FileLogger = new function InternalFileLogger() {
  this.buffer = [new NSString init];
  this.log = function(str) { this.buffer += str + "\n"; }
  this.terminate = function(c) {
    [this.buffer writeToFile:"/tmp/Tests_"+c+".log" atomically:YES];
    this.buffer = [new NSString init];
  }
}

var CombinedLogger = new function InternalCombinedLogger() {
  this.log = function(str) {
    FileLogger.log(str);
    NSLogLogger.log(str);
  }
  this.terminate = function(c) { FileLogger.terminate(c); }
}

// Default logger: combination of saving to a file in /tmp and logging to NSLog
var desiredLogger = CombinedLogger;

// => CONTEXTS
function beginContext(context) {
  desiredLogger.log("Running tests for context '"+context+"'...");
}

function endContext(context) {
  desiredLogger.log("" + passes + " assertions passed, " + fails + " assertions failed");
  desiredLogger.terminate(context);
  passes = 0; fails = 0;
}

function context(name, scope) {
  beginContext(name);
  scope();
  endContext(name);
}

function pass() {
  passes++;
}

function fail(desc) {
  fails++;
  desiredLogger.log("  * [FAILED] " + desc);
}

// => ASSERTIONS
// Now all based on the assertBlock helper, mostly stolen from JSUnitTest.

function assertBlock(block, desc) {
  try {
    block() ? pass() : fail(desc);
  } catch (e) { fail(desc) }
}

// Stuff that would work in plain-old JS.
function assertTrue(t, desc) {
  assertBlock(function() { return t == true; }, desc);
}

function assertFalse(t, desc) {
  assertBlock(function() { return t == false; }, desc);
}

function assertEquals(something, whatItShouldEqual, desc) {
  assertBlock(function() { return something == whatItShouldEqual; }, desc);
}

function assertNotEquals(something, whatItShouldEqual, desc) {
  assertBlock(function() { return something != whatItShouldEqual; }, desc);
}

// Obj-C/Cycript-specific assertions.
function assertRespondsToSelector(obj, sel, desc) {
  assertBlock(function() { return [obj respondsToSelector:(new Selector(sel))]; }, desc);
}

function assertIsKindOfClass(obj, className, desc) {
  assertBlock(function() { return [obj isKindOfClass:(objc_getClass(className))]; }, desc);
}

function assertNotKindOfClass(obj, className, desc) {
  assertBlock(function() { return ![obj isKindOfClass:objc_getClass(className)]; }, desc);
}

// => BENCHMARKS
// JS date objects are known to be up to 15ms off. Take that into consideration.

function assertRunsFasterThan(block, ms, iterations, desc) {
  // "On average, $block() runs faster than $ms milliseconds over $iterations iterations"
  var sum = 0;
  for (var i = 1; i <= iterations; i++) {
    var start = new Date();
    block();
    var end = new Date();
    sum += end - start;
  }
  assertBlock(function() { return (sum / iterations) < ms; }, desc);
}

function assertAlwaysRunsFasterThan(block, ms, iterations, desc) {
  // "Over $iterations iterations, $block() always ran faster than $ms milliseconds"
  assertBlock(function() {
      for (var i=1; i<= iterations; i++) {
        var start = new Date();
        block();
        var end = new Date();
        var delta = end - start;
        if (delta >= ms) return false;
      }
      return true;
  }, desc);
}
