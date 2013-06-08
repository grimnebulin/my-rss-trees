package HeadTrip;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://headtrip.keenspot.com/comic.rss',
    NAME  => 'headtrip',
    TITLE => 'Head Trip',
};


sub render {
    my ($self, $item) = @_;
    return $item->page->find('//img[contains(@src,"/comics/")]')->shift;
}


1;
