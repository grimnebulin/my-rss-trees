package ThisModernWorld;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://www.dailykos.com/user/Comics/rss.xml',
    NAME  => 'modernworld',
    TITLE => 'This Modern World',
};


sub init {
    shift->match_author('tom tomorrow');
}


1;
