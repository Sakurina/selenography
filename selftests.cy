#!/usr/bin/cycript

// Function that allows you to include external Cycript files.
function include(fn) {
  var t = [new NSTask init]; [t setLaunchPath:@"/usr/bin/cycript"]; [t setArguments:["-c", fn]];
  var p = [NSPipe pipe]; [t setStandardOutput:p]; [t launch]; [t waitUntilExit];  [t release];
  var s = [new NSString initWithData:[[p fileHandleForReading] readDataToEndOfFile] encoding:4];
  var r = this.eval(s.toString()); [s release]; return r;
}

// Include selenography directly; no test runner needed since we're testing ourselves.
include("selenography.cy");

context("Self-tests", function() {
  assertTrue(1 == 1, "1 == 1 should be true");
  assertTrue(1 == 2, "1 == 2 should be true (should fail)");
  assertTrue(YES, "YES should equate to true");
  assertFalse(1 == 2, "1 == 2 should be false");
  assertEquals(1, 1, "1 should equal 1");
  assertNotEquals(1, 2, "1 should not equal 2");
  assertEquals(1, 2, "1 should equal 2 (should fail)");
  assertNotEquals(1, 1, "1 should not equal 1 (should fail)");
  assertRespondsToSelector([new NSString init], "length", "Strings should respond to the length message");
  assertRespondsToSelector([new NSString init], "length:forLulz:", "Strings should respond to the length:forLulz: message (should fail)");
  assertIsKindOfClass([new NSString init], "NSString", "Strings should be an instance of NSString or one of its subclasses");
  assertIsKindOfClass([new NSMutableString init], "NSString", "Mutable strings should be an instance of NSString or one of its subclasses");
  assertIsKindOfClass([new NSMutableString init], "NSMutableString", "Mutable strings should be an instance of NSMutableString or one of its subclasses");
  assertIsKindOfClass([new NSMutableString init], "NSNumber", "Mutable strings should be an instance of NSNumber or one of its subclasses (should fail)");
  assertNotKindOfClass([new NSMutableString init], "NSNumber", "Mutable strings should not be an instance of NSNumber or one of its subclasses");
  assertRunsFasterThan(function() {
    var h = [new NSMutableArray init];
    var f = [new NSString init];
    [h addObject:f];
  }, 3, 100, "Initializing an array and adding a new string to it should be faster than 3 ms on average");
  assertAlwaysRunsFasterThan(function() {
    var h = [new NSMutableArray init];
    var f = [new NSString init];
    [h addObject:f];
  }, 5, 100, "Initializing an array and adding a new string to it should always be faster than 5 ms");
});

context("Seeing if multiple contexts work", function() { });
