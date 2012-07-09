package ComicsCurmudgeon;

use base qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://feeds.feedburner.com/joshreads',
    NAME  => 'comicscurmudgeon',
    TITLE => 'The Comics Curmudgeon',
};

sub render {
    my ($self, $item) = @_;
    $_->detach for $item->content->find(
        '//p[.//img[contains(@src,"doubleclick")]]'
    );
    return $item->content;
}


1;
