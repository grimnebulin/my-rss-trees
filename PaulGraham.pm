package PaulGraham;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME    => 'paulgraham',
    TITLE   => 'Paul Graham',
    FEED    => 'http://www.aaronsw.com/2002/feeds/pgessays.rss',
    LIMIT   => 3,
};


sub render {
    my ($self, $item) = @_;
    return $item->page->find('//p');
}


1;
