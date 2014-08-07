package Minifauna;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://www.wired.com/wiredscience/category/charismatic-minifauna/feed/',
    NAME  => 'minifauna',
    TITLE => 'Charismatic Minifauna',
};

my $NOSCRIPT = './/noscript[preceding-sibling::img/@data-lazy-src=img/@src]';


sub render {
    my ($self, $item) = @_;
    my ($content) = $item->page->find('//div[%s]', 'entry') or return;

    for my $ns ($self->find($content, $NOSCRIPT)) {
        $ns->parent->splice_content($ns->pindex - 1, 2, $ns->content_list);
    }

    return $content;

}


1;
