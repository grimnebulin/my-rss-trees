package DoodleTime;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'doodletime',
    TITLE => 'Doodle Time',
    FEED  => 'http://sarahseeandersen.tumblr.com/rss',
};


sub init {
    shift->match_category('comic');
}


1;
