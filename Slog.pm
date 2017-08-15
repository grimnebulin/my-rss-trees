package Slog;

use parent qw(BasicFeed RSS::Tree);
use strict;

use constant {
    FEED    => 'http://www.thestranger.com/seattle/Rss.xml',
    NAME    => 'slog',
    TITLE   => 'Savage Slog',
    CONTENT => [ '//div[%s]', 'postBody' ],
};


sub init {
    shift->match_creator('savage');
}

sub clean_feed {
    $_[1] =~ s/(&#x([0-9a-fA-F]+);)/_valid_char_hex($2) ? $1 : ""/ge;
}

sub _valid_char_hex {
    my $char = shift;
    my $ord  = hex $char;
    return $ord == 0x9 || $ord == 0xA || $ord == 0xD || $ord > 0x20;
}


1;
