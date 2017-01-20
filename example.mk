
let adder = fn(a, b) {
    return a + b;
};

let addTwo = fn(a) {
    return adder(2, a);
}

let addThree = fn(a) {
    return adder(3, a);
}

puts(addTwo(2), addThree(2));

let anArray = ["foo", "bar", "baz"];
puts(anArray[1]);
puts(first(anArray));
