package OOTS;

use base qw(MyRssBase);
use strict;

use constant {
    FEED  => 'http://www.giantitp.com/comics/oots.rss',
    NAME  => 'oots',
    TITLE => 'Order of the Stick',
};

sub render {
    my ($self, $item) = @_;
    return ($item->page->findnodes('//img[contains(@src,"comics/images")]'))[0];
}

1;
