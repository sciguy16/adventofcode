#!/usr/bin/env node

function is_nice(string) {
	// Contains 3 or more vowels
	var vcount = 0;
	for(var i = 0; i < string.length; i++) {
		if("aeiou".indexOf(string[i]) != -1)
			vcount++;
	}
	if(vcount < 3) {
		console.log(string + ": Insufficient vowellage");
		return false;
	}

	// Contains at least one double letter
	if(!string.match(/(.)\1/)) {
		console.log(string + ": No doubles");
		return false;
	}
	// Does not contain ab, cd, pq, or xy
	bad = [ "ab", "cd", "pq", "xy" ];
	for(var i = 0; i < 4; i++) {
		if(string.indexOf(bad[i]) > -1) {
			console.log(string + ": Contains a bad sequence :(");
			return false;
		}
	}

	console.log(string + ": nice");
	
	return true;
}

function is_nice_2(string) {
	// Pair of letters repeated
	if(!string.match(/(..).*\1/)) {
		console.log(string + ": No repeated double");
		return false;
	}

	// Single letter repeated
	if(!string.match(/(.).\1/)) {
		console.log(string + ": No repeated letter");
		return false;
	}

	return true;
}

function test() {
	if(!is_nice("ugknbfddgicrmopn")) throw "Test 1 failed";
	if(!is_nice("aaa")) throw "Test 2 failed";
	if(is_nice("jchzalrnumimnmhp")) throw "Test 3 failed";
	if(is_nice("haegwjzuvuyypxyu")) throw "Test 4 failed";
	if(is_nice("dvszwmarrgswjxmb")) throw "Test 5 failed";
}

function count_nice(file, nice_func) {
	var lines = require('fs').readFileSync('input.txt', 'utf-8')
		.split('\n');
	console.log(lines);
	var count = 0;
	for(var i = 0; i < lines.length; i++) {
		if(lines[i] && nice_func(lines[i])) {
			count += 1;
		}
	}

	return count;
}

function main() {
	console.log("Starting naughty-nice decider");
	test();
	var count = count_nice("input.txt", is_nice);
	var count2 = count_nice("input.txt", is_nice_2);
	console.log("The number of nice words is:", count);
	console.log("The number of nicer words is:", count2);
}


main();
