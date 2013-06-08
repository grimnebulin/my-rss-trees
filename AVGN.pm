package AVGN;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'avgn',
    TITLE => 'AVGN',
    FEED  => 'http://feeds2.feedburner.com/Cinemassacrecom',
};


sub render {
    my ($self, $item) = @_;
    $_->detach for $item->content->find(
        '//p[descendant::a[contains(@href,"doubleclick")]]|//div[%s]', 'feedflare'
    );
    return $item->content;
}


1;
