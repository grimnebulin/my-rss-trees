package ForLack;

use base qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'forlack',
    TITLE => 'For Lack of a Better Comic',
    FEED  => 'http://feedity.com/forlackofabettercomic-com/UFZaW1dQ.rss',
};

sub render {
    my ($self, $item) = @_;
    return $item->page->find('//img[starts-with(@alt,"Comic #")]');
}


1;
