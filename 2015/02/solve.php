#!/usr/bin/env php
<?php
function area(int $l, int $w, int $h) {
	// The l, w, and h need to be in nondecreasing order
	return 3*$l*$w + 2*$w*$h + 2*$h*$l;
}

assert(area(2, 3, 4) == 58);
assert(area(1, 1, 10) == 42);

function ribbon(int $l, int $w, int $h) {
	// assume l, w, h are in nondecreasing order
	return 2*($l + $w) + $l*$w*$h;
}

$total = 0;
$tot_ribbon = 0;
foreach(file("input.txt") as $line) {
	$dimensions = explode("x", rtrim($line));
	sort($dimensions);
	$total += area(...$dimensions);
	$tot_ribbon += ribbon(...$dimensions);
}

echo "Total area needed is $total sq feet\n";
echo "Ribbon needed is $tot_ribbon feet\n";

?>
