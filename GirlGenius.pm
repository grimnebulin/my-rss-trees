package GirlGenius;

use base qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://www.girlgeniusonline.com/ggmain.rss',
    NAME  => 'girlgenius',
    TITLE => 'Girl Genius',
};

sub render {
    my ($self, $item) = @_;
    return $item->page->find('//img[contains(@src,"/strips/")]')->shift;
}

1;
