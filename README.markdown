# Selenography
Selenography is a set of functions made to facilitate unit testing running iPhone applications or extensions via Cycript's ability to hook into running processes.

## A Brief Note
I developed Selenography to have an in-house testing framework for my SpringBoard hooks. Most, if not all development on it will go towards that goal. Very rarely will I use Selenography against (sandboxed) App Store applications or other processes, though it should work (theoretically).

## Dependencies
* A jailbroken iPhone or iPod touch
* [Cycript][1]
* Some way of getting on a shell; ideally OpenSSH, though there's no reason you couldn't do everything in MobileTerminal if you wanted to.

## How to Use
See the examples directory for a short, not-so-descriptive example. I plan on putting the FCSB tests in the examples directory once I'm done testing it to give people a better idea of real-world use. For now, this will have to do.

## Assertion Types
### Typical Assertions
* *assertTrue/assertFalse/assertEquals/assertNotEquals*
### Obj-C Assertions
* *assertRespondsToSelector:* Passes if the passed object responds to a selector
* *assertIsKindOfClass/assertNotKindOfClass:* Passes if the passed object is an instance of the passed in class or one of its subclasses.
* (soon?) *assertClassExists:* Passes if a class is found to exist via objc_getClass()
### Benchmark Assertions
* *assertRunsFasterThan:* Passes if the passed in block runs faster than N milliseconds over X iterations on average.
* *assertAlwaysRunsFasterThan:* Passes if the passed in block runs faster than N milliseconds each iteration for X iterations.

## Interesting Use Cases
* Environment testing; build a suite of tests to check for private methods your extension uses to quickly evaluate compatibility on new OS releases (without needing to dump any headers!)

[1]: http://cycript.org
