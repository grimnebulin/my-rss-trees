package Slog;

use parent qw(BasicFeed RSS::Tree);
use strict;

use constant {
    FEED    => 'http://feeds.thestranger.com/stranger/slog',
    NAME    => 'slog',
    TITLE   => 'Savage Slog',
    CONTENT => [ '//div[%s]', 'postBody' ],
};


sub init {
    shift->match_creator('savage');
}


1;
