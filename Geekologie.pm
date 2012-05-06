package Geekologie;

use base qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://www.geekologie.com/index.xml',
    NAME  => 'geekologie',
    TITLE => 'Geekologie',
};


sub render {
    my ($self, $item) = @_;
    $_->detach for $item->body->findnodes(
        '//p[descendant::a[contains(@href,"doubleclick")]]|//img[@height="1"]'
    );
    return $item->body;
}

1;
