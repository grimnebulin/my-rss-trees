package AngryFlower;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://interglacial.com/rss/bob_the_angry_flower.rss',
    NAME  => 'angryflower',
    TITLE => 'Bob the Angry Flower',
    LIMIT => 5,
};


sub render {
    my ($self, $item) = @_;
    return $item->page->find('//img[1]');
}


1;
