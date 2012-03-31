package Dilbert;

use base qw(MyRssBase);
use strict;

use constant {
    FEED  => 'http://feeds.feedburner.com/DilbertDailyStrip?format=xml',
    NAME  => 'dilbert',
    TITLE => 'Dilbert',
};

sub render {
    my ($self, $item) = @_;
    $_->detach for $item->body->findnodes('//a[contains(@href,"doubleclick")]');
    return $item->body;
}

1;
