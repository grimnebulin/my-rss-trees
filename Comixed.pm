package Comixed;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'comixed',
    TITLE => 'Comixed',
    FEED  => 'http://feeds.feedburner.com/comixed/CMX',
};


sub render {
    my ($self, $item) = @_;

    if (my ($bound) = $item->content->find(
        '//div[.//a[contains(@href,"cheezburger.com/comixed/tag/")]]'
    )) {
        my ($prev) = $bound->findnodes(
            'preceding-sibling::*[1][contains(normalize-space()," by:")]'
        );
        $bound->parent->splice_content(($prev || $bound)->pindex);
    }

    return;

}


1;
