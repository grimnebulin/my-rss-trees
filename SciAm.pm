package SciAm;

use base qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://rss.sciam.com/ScientificAmerican-Global',
    NAME  => 'sciam',
    TITLE => 'Scientific American',
};


sub render {
    my ($self, $item) = @_;
    return $item->page->findnodes('//div[@id="articleContent"]');
}


1;
