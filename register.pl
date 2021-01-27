#!/usr/bin/perl 
use warnings;
use strict;

use DBI;
use JSON;
use Data::Dumper;
use Try::Tiny;
require '../Environment.pm';


print "Content-type: text/plain\n\n";
# print Dumper(\%ENV);
# test();

store_http();


sub store_http {
    my $url = '';
    if ($ENV{'HTTPS'}) {
        $url .= 'https://';
    } else {
        $url .= 'http://';
    }
    $url .= $ENV{'HTTP_HOST'};
    $url .= $ENV{'REQUEST_URI'};

    my $method = $ENV{'REQUEST_METHOD'};
    my $body = '';
    if ( $method eq "POST" ) {
        read( STDIN, $body, $ENV{'CONTENT_LENGTH'} );
    }

    my $originationNumber = '';
    my $destinationNumber = '';
    my $messageBody = '';
    try {
        my $content = decode_json($body);
        my $ref = ref($content);

        if ($ref eq 'HASH') {
            my $message = $content->{Message};

            my $mcontent = decode_json($message);
            my $mhref = ref($mcontent);

            if ($mhref eq 'HASH') {
                $originationNumber = $mcontent->{originationNumber};
                $destinationNumber = $mcontent->{destinationNumber};
                $messageBody       = $mcontent->{messageBody};
            }
        }
    } catch {};

    my ($db_name, $db_user, $db_pass) = Environment::database();

    my $dbh = DBI->connect( "dbi:Pg:dbname=$db_name;host=localhost;port=5432;",
        $db_user, $db_pass, { RaiseError => 0, PrintError => 1 } )
        || warn "Cannot connect to database: $DBI::errstr";

    my $query = "INSERT INTO sms (url,method,body,origination_number,destination_number,message_body)
                 VALUES (?,?,?,?,?,?)
                ";
    my $sth = $dbh->prepare($query);
    my $rv = $sth->execute($url, $method, $body, $originationNumber, $destinationNumber, $messageBody);
    if (!defined $rv) {
        print("Database error: " . $dbh->errstr . "\n");
    }
    $sth->finish();
}


sub test {
    my $body =  '{
        "Type" : "Notification",
        "MessageId" : "ad467f80-ef62-55bd-ad0e-270b69dda842",
        "TopicArn" : "arn:aws:sns:us-east-1:756132315733:receivesms",
        "Message" : "{\"originationNumber\":\"+13516668296\",\"destinationNumber\":\"+14708237179\",\"messageKeyword\":\"keyword_756132315733\",\"messageBody\":\"Test message 4\",\"inboundMessageId\":\"36adfc1a-0e05-5c01-b04b-a49188ba62d4\",\"previousPublishedMessageId\":\"ea954a09-701b-5bcc-b2c2-12820b6c34d5\"}",
        "Timestamp" : "2021-01-27T15:19:27.895Z",
        "SignatureVersion" : "1",
        "Signature" : "diFbVhXEq5RdoOhPV2eiA+7Jfn/Xc4wVF73vg2MgZ5ZMwDTh0EU+l/nzl263Aok7zMxgmrgD8bx8AinNyMZrHHa+R2vW8zWp0WUkJ5LzbA8hWRxoqrXjDXSLh2fvEDUPd49IHT3Jtot9zeCWDtXKBX0DRTbplJ6uSY5WgOlLR1Uvqjp7kLmmYgJ1hkTZvWrrGj7bba2okFsP2gVSJk17YxblEgdZVNTg9fHNj31yoR01B2nynUcCXoVKRNGj2MUFu27XfbDoTgldF7EKeuCBAaDf0Jw1oHYw4yTgW8vO/LM3G46e3g+Aoh3EATdbj3XhPlQsnEtY4ywYE19aLEiqWQ==",
        "SigningCertURL" : "https://sns.us-east-1.amazonaws.com/SimpleNotificationService-010a507c1833636cd94bdb98bd93083a.pem",
        "UnsubscribeURL" : "https://sns.us-east-1.amazonaws.com/?Action=Unsubscribe&SubscriptionArn=arn:aws:sns:us-east-1:756132315733:receivesms:dd326757-d4c9-4cb9-9c88-4f8f86ff5818"
    }
    ';

    my $originationNumber = '';
    my $destinationNumber = '';
    my $messageBody = '';

    print $body;

    try {
        my $content = decode_json($body);
        my $ref = ref($content);
        print "ref = $ref\n";

        if ($ref eq 'HASH') {
            my $message = $content->{Message};
            print "Message = $message\n";

            my $mcontent = decode_json($message);
            my $mhref = ref($mcontent);
            print "mhref = $mhref\n";

            if ($mhref eq 'HASH') {
                $originationNumber = $mcontent->{originationNumber};
                $destinationNumber = $mcontent->{destinationNumber};
                $messageBody       = $mcontent->{messageBody};
            }
        }
    } catch {};

    print "originationNumber = $originationNumber\n";
    print "destinationNumber = $destinationNumber\n";
    print "messageBody = '$messageBody'\n";
}
