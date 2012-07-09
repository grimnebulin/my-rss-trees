package AngryFlower;

use base qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://interglacial.com/rss/bob_the_angry_flower.rss',
    NAME  => 'angryflower',
    TITLE => 'Bob the Angry Flower',
};

my $TEXT_LIMIT = 1000;

sub render {
    my ($self, $item) = @_;

    for my $td ($item->page->find('//td')) {
        if (length($td->as_text) >= $TEXT_LIMIT) {
            return $td->content_list;
        }
    }

    return $item->page->find('//img[1]');

}


1;
