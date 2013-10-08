package Pandyland;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED => 'http://pandyland.net/feed/',
    NAME => 'pandyland',
    TITLE => 'Pandyland',
};


sub render {
    my ($self, $item) = @_;
    my ($image) = $item->page->find('//div[%s]/img', 'comicpane') or return;
    return $image;
}


1;
