/*
 Test code for grammar.
 */

// Declare variable:
let a = 1 + 2;
// Declare constant:
const b = 3 + 4;

c = 1 ^ 2 ^ 3;

let d;
let x = 2;
let y = 3;

if (x > y) {
    d = x;
} else {
    d = y;
}

let foobar = if (x > y) {
    x
} else {
    y
};

let myFunc = fn() {
    return 23;
};

let add = fn(a, b) {
    return a + b;
};

let max = fn(a, b) {
    if (a > b) {
        return a;
    } else {
        return b;
    }
};

let biggest = max(2, 3);

let aBoolean = true;

let aString = "Hello, world!";

puts(aString);

let myArray = ["one", "two", "three"];
puts(myArray[1]);
puts(["foo", "bar", "baz"]);

let array = fn() {
    return ["foo", "bar", "baz"];
};

array()[2];

let emptyHash = {};
let myHash = {"name": "Jimmy", "age": 72, "band": "Led Zeppelin"};
puts(myHash["name"]);
