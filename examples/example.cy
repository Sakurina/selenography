#!/usr/bin/cycript -p SpringBoard
// The above line lets you specify what process to hook into.

// The -p option takes in names or process IDs. Ideally, you
// should probably use names to make sure your tests always
// hook the right process.

// You could also theoretically test other cycript files, in
// which case you would not need to use the -p option at all.
// You would need to include your file; see "Cycript Tricks"
// on the iPhone Dev Wiki for documentation on that.

beginContext("Example")
assertTrue(1 == 1, "1 should equal 1");
assertTrue(1 == 2, "1 should equal 2 (this will fail)");
endContext();

// Just to show that there can be multiple contexts in the
// same file...
beginContext("Second Context")
assertTrue(1 == 1, "1 should equal 1");
assertTrue(1 == 2, "1 should equal 2 (this will fail)");
endContext();

// Output from these contexts will be sent directly to the
// syslog, which you can see through Xcode or the iPhone
// Configuration Utility.

// Selenography /also/ automatically saves output to files
// in /tmp so you can cat them in a shell script if you
// want to.

