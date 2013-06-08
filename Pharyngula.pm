package Pharyngula;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'pharyngula',
    TITLE => 'Pharyngula',
    FEED  => 'http://feeds.feedburner.com/freethoughtblogs/pharyngula',
    KEEP_GUID => 1,
};


sub render {
    my ($self, $item) = @_;
    $_->detach for $item->content->find(
        '//p[descendant::a[contains(@href,"doubleclick")]]|//img[@height="1"]'
    );
    return $item->content;
}


1;
