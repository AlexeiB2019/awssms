#!/usr/bin/perl 
use warnings;
use strict;

use DBI;
require '../Environment.pm';


if (@ARGV != 2) {
	print "Send SMS via AWS, example: ./send.pl '+14708237179' 'Test message'\n";
	exit(0);
}

my $phone   = $ARGV[0];
my $message = $ARGV[1];


send_sms($phone, $message);
save_sms($phone, $message);


sub send_sms {
	my $phone = shift;
	my $message = shift;

	# my $response = `aws sns publish --phone-number $phone --message '$message'`;
	# print "$response\n";

	system("aws", "sns", "publish", "--phone-number", $phone, "--message", $message);
}


sub save_sms {
	my $phone = shift;
	my $message = shift;

    my ($db_name, $db_user, $db_pass) = Environment::database();

    my $dbh = DBI->connect( "dbi:Pg:dbname=$db_name;host=localhost;port=5432;",
        $db_user, $db_pass, { RaiseError => 0, PrintError => 1 } )
        || warn "Cannot connect to database: $DBI::errstr";

    my $query = "INSERT INTO sms (destination_number,message_body)
                 VALUES (?,?)
                ";
    my $sth = $dbh->prepare($query);
    my $rv = $sth->execute($phone, $message);
    if (!defined $rv) {
        print("Database error: " . $dbh->errstr . "\n");
        exit(1);
    }
    $sth->finish();
}
