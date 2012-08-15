package Cyanide;

use base qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'cyanide',
    TITLE => 'Cyanide & Happiness',
    FEED  => 'http://feeds.feedburner.com/Explosm',
};

sub render {
    my ($self, $item) = @_;
    my ($comic) = $item->page->find('//img[contains(@src,"/files/") and starts-with(@alt,"Cyanide")]');
    return $comic if $comic;
    return $item->page->find('//div[starts-with(@id,"post_message_")]');
}

1;
