package Beefpaper;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME => 'beefpaper',
    TITLE => 'Beefpaper',
    FEED => 'http://beefpaper.com/?feed=rss2',
};


sub render {
    my ($self, $item) = @_;
    my ($image) = $item->page->find('//div[@id="comic"]//img') or return;
    return ($image, $item->page->find('//div[%s]', 'entry'));
}


1;
