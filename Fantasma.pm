package Fantasma;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://fantasmacomic.net/feed/',
    NAME  => 'fantasma',
    TITLE => 'Fantasma',
};

sub render {
    my ($self, $item) = @_;
    my ($img) = $item->page->find('//div[@id="comic"]//img');
    my ($entry) = $item->page->find('//div[%s]', 'entry');
    return ($img, $entry);
}


1;
