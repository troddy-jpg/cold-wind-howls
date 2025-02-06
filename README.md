# Lua Test Frame work
## Before you use
1. You can only test general Lua code and no pico8 specific functions like rect, spr and so on...
2. You will have to copy functions from the .p8 file into the test/tested_code.lua file in order to test them... - and if you do test driven development - copy them back after doing some adjustments... 
4. I know this is tedious! Maybe I find a better solution in the future, I am open for suggestions!

## Setup a Test

1. Edit the test in test/test.lua and test/tested_code.lua

2. make sure a Lua interpetor is installed so you can run .lua files from your terminal or commandline.

5. run ```lua main.lua``` within the test folder - to test

## API
The api is keept really simple, use t.assert_equal(a, b, "a has to equal b").

a and b are the two objects / variables or function outputs you whish to compare, the third (and optional) parameter is a description. The result will look like this for passed tests:

```
...>lua ./lib/main.lua         


-----Test starts-----
[info]: test succeded: 4/4 passed
```

And like this for failed tests

```
...>lua ./lib/main.lua


-----Test starts-----
--> [error]: test sort failed -> 1,2,3,4, != 1,2,3,3,
--> [error]: 1/3 tests failed!
```
