package LoadingArtist;

use parent qw(RSS::Tree);
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
    my ($image) = $item->page->find('//div[starts-with(@id, "post-")]//div[%s]//img', 'comic') or return;
    if (my $src = $image->attr('data-cfsrc', undef)) {
        $image->attr('src', $src);
    }
    $image->attr('style', undef);
    my ($body) = $item->page->find('//div[%s]', 'body');
    return ($image, $body);
}


1;
