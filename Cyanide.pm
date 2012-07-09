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
    my ($comic) = $item->page->find('//img[contains(@src,"/files/Comics/")]');
    return $comic if $comic;
    my ($post)  = $item->page->find('//div[starts-with(@id,"post_message_")]');
    return $post if $post;
    return;
}

1;
