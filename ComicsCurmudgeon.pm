package ComicsCurmudgeon;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://feeds.feedburner.com/joshreads',
    NAME  => 'comicscurmudgeon',
    TITLE => 'The Comics Curmudgeon',
};

sub render {
    my ($self, $item) = @_;
    return $item->content->remove(
        '//map|//*[self::p or self::table][descendant::img[contains(@src,"doubleclick") or contains(@src,"projectwonderful")]]'
    );
}


1;
