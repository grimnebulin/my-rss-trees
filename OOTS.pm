package OOTS;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'oots',
    TITLE => 'Order of the Stick',
    FEED  => 'http://www.giantitp.com/comics/oots.rss',
    LIMIT => 10,
};


sub render {
    my ($self, $item) = @_;
    my ($img) = $item->page->find('//img[contains(@src,"/comics/images/")]') or return;
    return $img;
}


1;
