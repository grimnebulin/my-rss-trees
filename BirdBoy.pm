package BirdBoy;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'birdboy',
    TITLE => 'Bird Boy',
    FEED  => 'http://bird-boy.com/feed/',
};


sub render {
    my ($self, $item) = @_;
    my ($strip) = $item->page->find('//img[contains(@src,"/comics/")]') or return;
    return ($strip, $item->page->find('//div[%s]//div[%s]', 'post-content', 'entry'));
}


1;
