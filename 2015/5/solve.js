#!/usr/bin/env node

function is_nice(string) {
	// Contains 3 or more vowels
	var vcount = 0;
	for(var i = 0; i < string.length; i++) {
		if("aeiou".indexOf(string[i]) != -1)
			vcount++;
	}
	if(vcount < 3) {
		console.log("Insufficient vowellage");
		return false;
	}

	// Contains at least one double letter
	if(!string.match(/(.)\1/)) {
		console.log("No doubles");
		return false;
	}
	// Does not contain ab, cd, pq, or xy
	bad = [ "ab", "cd", "pq", "xy" ];
	for(var i = 0; i < 4; i++) {
		console.log("bad[i] is " + bad[i]);
		if(string.indexOf(bad[i]) > 0) {
			console.log("Contains a bad sequence :(");
			return false;
		}
	}

	console.log("nice");
	
	return true;
}


function test() {
	if(!is_nice("ugknbfddgicrmopn")) throw "Test 1 failed";
	if(!is_nice("aaa")) throw "Test 2 failed";
	if(is_nice("jchzalrnumimnmhp")) throw "Test 3 failed";
	if(is_nice("haegwjzuvuyypxyu")) throw "Test 4 failed";
	if(is_nice("dvszwmarrgswjxmb")) throw "Test 5 failed";
}

function count_nice(file) {
	return 4;
}

function main() {
	console.log("Starting naughty-nice decider");
	test();
	var count = count_nice("input.txt");
}


main();
