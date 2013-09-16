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
    return $item->description->remove(
        '//p[.//a[contains(@href,"doubleclick")]]|//div[%s]', 'feedflare'
    );
}


1;
