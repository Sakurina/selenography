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

function context(name, scope) {
  beginContext(name);
  scope();
  endContext();
}

function pass() {
  passes++;
}

function fail(desc) {
  fails++;
  NSLog("  * [FAILED] %@", desc);
  contextBuffer += "  * [FAILED] " + desc + "\n";
}

// => ASSERTIONS
// Now all based on the assertBlock helper,
// mostly stolen from JSUnitTest.

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
