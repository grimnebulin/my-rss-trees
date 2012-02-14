package HeadTrip;

use base qw(MyRssBase);
use strict;

use constant {
    FEED  => 'http://headtrip.keenspot.com/comic.rss',
    NAME  => 'headtrip',
    TITLE => 'Head Trip',
};

sub render {
    my ($self, $item) = @_;
    return ($item->page->findnodes('//img[contains(@src,"/comics/")]'))[0];
}


1;
