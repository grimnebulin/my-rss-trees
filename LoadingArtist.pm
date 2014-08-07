package LoadingArtist;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://feeds.feedburner.com/LoadingArtist',
    NAME  => 'loadingartist',
    TITLE => 'Loading Artist',
};


sub render {
    my ($self, $item) = @_;
    my ($image) = $item->page->find('//div[%s]/img', 'comic') or return;
    return $image;
}


1;
