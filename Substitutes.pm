package Substitutes;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME   => 'substitutes',
    TITLE  => 'The Substitutes',
    FEED   => 'http://thesubstitutescomic.com/rss',
    RENDER => [ '//figure[%s]//img', 'photo-hires-item' ],
};


1;
