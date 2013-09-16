package Oblyvian;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'oblyvian',
    TITLE => 'Oblyvian',
    FEED =>  'http://oblyvian.tumblr.com/rss',
};


sub init {
    shift->match_category('doodle');
}


1;
