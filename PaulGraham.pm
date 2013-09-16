package PaulGraham;

use parent qw(BasicFeed RSS::Tree);
use strict;

use constant {
    NAME    => 'paulgraham',
    TITLE   => 'Paul Graham',
    FEED    => 'http://www.aaronsw.com/2002/feeds/pgessays.rss',
    LIMIT   => 3,
    CONTENT => '//table[not(.//table)]',
};



1;
