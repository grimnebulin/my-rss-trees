package LoadingArtist;

use parent qw(AlternateInterfaces RSS::Tree);
use strict;

use constant {
    FEED  => 'http://feeds.feedburner.com/LoadingArtist',
    NAME  => 'loadingartist',
    TITLE => 'Loading Artist',
    LIMIT => 3,
    AUTORESOLVE => 'follow',
};


sub render {
    my ($self, $item) = @_;
    my ($image) = $item->page->find('//div[%s]//img', 'comic') or return;
    my ($body) = $item->page->find('//div[%s]', 'body');
    return ($image, $body);
}


1;
