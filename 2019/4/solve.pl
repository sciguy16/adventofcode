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
	
	# Double digit
	unless ("$password" =~ /.*(\d).*\1.*/) {
		if ($DEBUG) { print "Not double\n"; }
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

	if ($DEBUG) { print "Valid!\n"; }

	return 1;
}

unless (is_valid(111111)) {
	print "Test 1 failed\n";
	exit;
}

if (is_valid(223450)) {
	print "Test 2 failed\n";
	exit;
}

if (is_valid(123789)) {
	print "Test 3 failed\n";
	exit;
}

$count = 0;
for (my $idx = 359282; $idx < 820401; $idx++) {
	if (is_valid($idx)) {
		$count++;
	}
}

print "Count is: $count\n";
