package Slashdot;

use base qw(MyRssBase);
use strict;

use constant {
    FEED  => 'http://rss.slashdot.org/Slashdot/slashdot',
    NAME  => 'slashdot',
    TITLE => 'Slashdot',
};


sub render {
    my ($self, $item) = @_;
    return $item->page->findnodes('//div[%s]', 'body');
}


1;
