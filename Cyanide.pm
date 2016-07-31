package Cyanide;

use URI;
use URI::QueryParam;
use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'cyanide',
    TITLE => 'Cyanide & Happiness',
    FEED  => 'http://feeds.feedburner.com/Explosm',
    AGENT_ID => 'Anything',
};

sub render {
    my ($self, $item) = @_;

    my ($comic) = $item->page->find('//img[@id="main-comic"]');
    return $comic if $comic;

    return $item->page->find('//div[starts-with(@id,"post_message_")]');

}

1;
