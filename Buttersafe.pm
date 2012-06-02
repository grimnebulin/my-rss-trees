package Buttersafe;

use base qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://feeds.feedburner.com/buttersafe/',
    NAME  => 'buttersafe',
    TITLE => 'Buttersafe',
};


sub render {
    my ($self, $item) = @_;
    return $item->page->findnodes('//div[@id="comic"]/img');
}


1;
