package MegaCynics;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'megacynics',
    TITLE => 'MegaCynics',
    FEED  => 'http://www.megacynics.com/feed/',
};

sub render {
    my ($self, $item) = @_;
    return $item->page->find('//img[contains(@src,"/img/comics/")]');
}


1;
