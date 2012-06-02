package Dilbert;

use base qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://feeds.feedburner.com/DilbertDailyStrip?format=xml',
    NAME  => 'dilbert',
    TITLE => 'Dilbert',
};


sub render {
    my ($self, $item) = @_;
    $_->detach for $item->description->findnodes('//a[contains(@href,"doubleclick")]');
    return $item->description;
}


1;
