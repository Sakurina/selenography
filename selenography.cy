//
// cycript unit testing framework for MS tweaks
//
//

// Include NSLog
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

// Unit tests for the unit testing framework; ironic
//function runSelfTests() {
  //beginContext("Self-tests");
  //assertTrue(1 == 1, "1 == 1 should be true");
  //assertTrue(1 == 2, "1 == 2 should be true (should fail)");
  //assertTrue(YES, "YES should equate to true");
  //assertFalse(1 == 2, "1 == 2 should be false");
  //assertEquals(1, 1, "1 should equal 1");
  //assertEquals(1, 2, "1 should equal 2 (should fail)");
  //endContext();
  //beginContext("Seeing if this got reset");
  //endContext();
//}
