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

beginContext("Self-tests");
assertTrue(1 == 1, "1 == 1 should be true");
assertTrue(1 == 2, "1 == 2 should be true (should fail)");
assertTrue(YES, "YES should equate to true");
assertFalse(1 == 2, "1 == 2 should be false");
assertEquals(1, 1, "1 should equal 1");
assertEquals(1, 2, "1 should equal 2 (should fail)");
endContext();

beginContext("Seeing if this got reset");
endContext();
