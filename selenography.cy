// selenography - unit testing for iPhone apps/extensions via Cycript

// Include NSLog.
NSLog_ = dlsym(RTLD_DEFAULT, "NSLog")
NSLog = function() { var types = 'v', args = [], count = arguments.length; for (var i = 0; i != count; ++i) { types += '@'; args.push(arguments[i]); } new Functor(NSLog_, types).apply(null, args); }

var passes = 0;
var fails = 0;
var contextName = ""
var contextBuffer = ""

function beginContext(context) {
  contextName = context
  NSLog("Running tests for context '%@'...", contextName);
  contextBuffer = "Running tests for context '"+contextName+"'...\n";
}

function endContext() {
  NSLog("%@ assertions passed, %@ assertions failed", passes, fails);
  contextBuffer += "" + passes + " assertions passed, " + fails + " assertions failed\n\n";
  [contextBuffer writeToFile:"/tmp/Tests_"+contextName+".log" atomically:NO];
  passes = 0;
  fails = 0;
  contextName = "";
  contextBuffer = "";
}

function pass() {
  passes++;
}

function fail(desc) {
  fails++;
  NSLog("  * [FAILED] %@", desc);
  contextBuffer += "  * [FAILED] " + desc + "\n";
}

function assertTrue(t, desc) {
  assertEquals(t, true, desc);
}

function assertFalse(t, desc) {
  assertEquals(t, false, desc);
}

function assertEquals(something, whatItShouldEqual, desc) {
  try {
    if (something == whatItShouldEqual)
      pass();
    else
      fail(desc);
  } catch (err) {
    fail();
  }
}

function assertClassExists(name) {
  try {
    if (objc_getClass(name) != nil)
      pass();
    else
      fail(name + " should exist");
  } catch (err) {
      fail(name + " should exist");
  }
}
