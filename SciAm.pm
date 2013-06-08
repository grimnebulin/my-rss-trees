package SciAm;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://rss.sciam.com/ScientificAmerican-Global',
    NAME  => 'sciam',
    TITLE => 'Scientific American',
};


sub render {
    my ($self, $item) = @_;
    my ($content) = $item->page->find('//div[@id="articleContent"]')
        or return;
    $_->detach for $content->findnodes('child::div[%s]', 'moduleHolder');
    return $content;
}


1;
