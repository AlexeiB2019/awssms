#!/usr/bin/perl 
use warnings;
use strict;

if (@ARGV != 2) {
	print "Send SMS via AWS, example: ./send.pl '+14708237179' 'Test message'\n";
	exit(0);
}

my $phone   = $ARGV[0];
my $message = $ARGV[1];

# my $response = `aws sns publish --phone-number $phone --message '$message'`;
# print "$response\n";

system("aws", "sns", "publish", "--phone-number", $phone, "--message", $message);
