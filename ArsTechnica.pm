package ArsTechnica;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'arstech',
    TITLE => 'Ars Technica',
    FEED  => 'http://feeds.arstechnica.com/arstechnica/index/',
};


sub render {
    my ($self, $item) = @_;
    return $item->page->find('//div[%s]', 'article-content');
}


1;
