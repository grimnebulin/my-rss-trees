package Slashdot;

use base qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://rss.slashdot.org/Slashdot/slashdot',
    NAME  => 'slashdot',
    TITLE => 'Slashdot',
};


sub render {
    my ($self, $item) = @_;
    return $item->page->find('//div[%s]', 'body');
}


1;
