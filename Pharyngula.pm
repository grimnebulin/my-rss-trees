package Pharyngula;

use base qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'pharyngula',
    TITLE => 'Pharyngula',
    FEED  => 'http://feeds.feedburner.com/freethoughtblogs/pharyngula',
};


sub render {
    my ($self, $item) = @_;
    $_->detach for $item->content->findnodes(
        '//p[descendant::a[contains(@href,"doubleclick")]]|//img[@height="1"]'
    );
    return $item->content;
}


1;
