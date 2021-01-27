#!/usr/bin/perl 
use warnings;
use strict;

use DBI;
require '../Environment.pm';


print_sms_list();


sub print_sms_list {
    print "       Date       |     From     |      To      |     Message                       \n";
    print "------------------+--------------+--------------+-----------------------------------\n";

    my ($db_name, $db_user, $db_pass) = Environment::database();

    my $dbh = DBI->connect( "dbi:Pg:dbname=$db_name;host=localhost;port=5432;",
        $db_user, $db_pass, { RaiseError => 0, PrintError => 1 } )
        || warn "Cannot connect to database: $DBI::errstr";

    my $query = "SELECT SUBSTRING(created::text FOR 16),
                        origination_number,
                        destination_number,
                        message_body
                 FROM sms
                 ORDER BY id
                ";
    my $sth = $dbh->prepare($query);
    my $rv = $sth->execute();
    if (!defined $rv) {
        print("Database error: " . $dbh->errstr . "\n");
        exit(1);
    }
    while (my @array = $sth->fetchrow_array()) {
        my $date    = $array[0];
        my $from    = $array[1];
        my $to      = $array[2];
        my $message = $array[3];

        if ($from) {
            print " $date | $from | $to | $message\n";
        }
    }
    $sth->finish();
}
