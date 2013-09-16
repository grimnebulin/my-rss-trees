package APOD;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'apod',
    TITLE => 'APOD',
    FEED  => 'http://apod.nasa.gov/apod.rss',
};


sub render {
    my ($self, $item) = @_;
    my ($h1)  = $item->page->find('//h1') or return;
    my ($pic) = $h1->findnodes('following-sibling::p[last()]') or return;
    my $top   = $h1->parent;

    my ($tomorrow) = $top->findnodes(
        'following-sibling::*[contains(.,"Tomorrow\'s picture")]'
    ) or return;

    $_->attr('target', '_blank') for $pic->findnodes('.//img');

    my @text = ($top->parent->content_list)[
        $top->pindex + 1 .. $tomorrow->pindex - 1
    ];

    return ($pic, @text);
}


1;
