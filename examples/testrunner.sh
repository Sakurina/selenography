#!/bin/bash
# Selenography Test Runner
#   This is just a normal shell script to run the tests.
#
#   If you had setup/teardown to execute between contexts,
#   this is where you'd do it.

# Since we're hooking SpringBoard, we want to make the
# Selenography functions load. Once loaded, they will
# persist for all other tests hooking into SpringBoard
# until the user resprings.
cycript -p SpringBoard ../selenography.cy

# Since the cycript hook is defined at the top of the
# file, we can just run it like this.
./example.cy

# cat out the test results.
cat /tmp/Tests_Example.log
cat /tmp/Tests_Second\ Context.log
