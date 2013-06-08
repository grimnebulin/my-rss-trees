package Geekologie;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://www.geekologie.com/index.xml',
    NAME  => 'geekologie',
    TITLE => 'Geekologie',
};


sub render {
    my ($self, $item) = @_;
    return $item->description->remove(
        '//p[descendant::a[contains(@href,"doubleclick")]]|//img[@height="1"]'
    );
}

1;
