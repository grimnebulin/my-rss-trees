package SROMG;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://www.mezzacotta.net/garfield/rss.xml',
    NAME  => 'sromg',
    TITLE => 'Square Root of Minus Garfield',
};

sub render {
    my ($self, $item) = @_;

    my @comments = $item->page->find(
        '//p[contains(string(),"The author writes")]'
    );

    if (@comments) {
        splice @comments, 1;
        for my $sibling ($comments[0]->findnodes('following-sibling::*')) {
            last if $sibling->tag ne 'p';
            push @comments, $sibling;
        }
    }

    return ($self->SUPER::render($item), @comments);

}


1;
