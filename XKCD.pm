package XKCD;

use HTML::Element;
use base qw(RSS::Tree);
use strict;

sub new {
    my $class = shift;

    my $self = $class->SUPER::new(
        'http://xkcd.com/rss.xml',
        'http://seanmcafee.name/rss/',
        'xkcd', 'XKCD',
    );

    $self->set_cache(
        dir   => "$ENV{HOME}/.rss-cache",
        feed  => 60 * 5,
        items => 60 * 60 * 24 * 30 * 12,
    );

    return $self;

}

sub render {
    my ($self, $item) = @_;
    my ($image) = $item->body->findnodes('//img');
    $image->postinsert(
        HTML::Element->new_from_lol(['p', ['i', $image->attr('title')]])
    ) if $image;
    return $item->body;
}


1;
