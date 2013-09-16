package Randi;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'randi',
    TITLE => 'Randi Speaks',
    FEED  => 'http://www.randi.org/site/index.php?format=feed&type=rss',
};


sub init {
    shift->match_author('randi');
}


1;
