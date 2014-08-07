package Skepchick;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'skepchick',
    TITLE => 'Skepchick',
    FEED  => 'http://skepchick.org/feed/',
};


sub init {
    shift->match_creator('watson');
}


1;
