package GirlGenius;

use base qw(MyRssBase);
use strict;

use constant {
    FEED  => 'http://www.girlgeniusonline.com/ggmain.rss',
    NAME  => 'girlgenius',
    TITLE => 'Girl Genius',
};

sub render {
    my ($self, $item) = @_;
    return ($item->page->findnodes('//img[contains(@src,"/strips/")]'))[0];
}


1;
