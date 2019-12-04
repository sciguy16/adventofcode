#!/usr/bin/env perl

print "Loading password machine\n";
$DEBUG = 0;

sub is_valid {
	my ($password) = @_;
	if ($DEBUG) { print "Testing the password $password\n"; }

	# Six digit number
	unless (length "$password" == 6) {
		if ($DEBUG) { print "wrong length"; }
		return 0;
	}

	# Nondecreasing
	my $prev = 0;
	for (split '',"$password") {
		#print "$_\n";
		if ($_ < $prev) {
			# digit is smaller than the last one
			if ($DEBUG) { print "Not nondecreasing\n"; }
			return 0;
		}
		$prev = $_;
	}
	
	# Double digit
	for $digit (0,1,2,3,4,5,6,7,8,9) {
		my @c = "$password" =~ /$digit/g;
		my $count = @c;
		if ($count == 2) {
			if ($DEBUG) { print "Valid!\n"; }
			return 1;
		}
	}

	if ($DEBUG) { print "Not double\n"; }

	return 0;
}

unless (is_valid(112233)) {
	print "Test 1 failed\n";
	exit;
}

if (is_valid(123444)) {
	print "Test 2 failed\n";
	exit;
}

unless (is_valid(111122)) {
	print "Test 3 failed\n";
	exit;
}

unless (is_valid(111223)) {
	print "test 4 failed\n";
	exit;
}

if ($DEBUG) { exit; }

$count = 0;
for (my $idx = 359282; $idx < 820401; $idx++) {
	if (is_valid($idx)) {
		$count++;
	}
}

print "Count is: $count\n";
