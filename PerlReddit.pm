package PerlReddit;

use parent qw(Reddit);
use strict;

use constant {
    NAME  => 'perlreddit',
    TITLE => 'Perl',
    FEED  => 'https://www.reddit.com/r/perl/.rss',
};

1;
