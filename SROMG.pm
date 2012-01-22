package SROMG;

use RSS::Tree;
use strict;

our @ISA = qw(RSS::Tree);


sub new {
    my $class = shift;

    my $self = $class->SUPER::new(
        'http://www.mezzacotta.net/garfield/rss.xml',
        'http://seanmcafee.name/rss/',
        'sromg', 'Square Root of Minus Garfield'
    );

    $self->set_cache(
        dir   => "$ENV{HOME}/.rss-cache",
        feed  => 60 * 5,
        items => 60 * 60 * 24 * 30,
    );

    return $self;

}

sub uri_for {
    my ($self, $item) = @_;
    return $item->guid;
}

sub postprocess_item {
    my ($self, $item) = @_;
    $item->{guid} .= '#';
}

sub render {
    my ($self, $item) = @_;
    my @comments = $item->page->findnodes(
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
