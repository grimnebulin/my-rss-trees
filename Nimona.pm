package Nimona;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://gingerhaze.com/nimona/rss.xml',
    NAME  => 'nimona',
    TITLE => 'Nimona',
};


sub render {
    my ($self, $item) = @_;
    $item->description->remove('//div[%s]', 'item-list');
    return;
}


1;
