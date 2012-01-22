package OOTS;

use base qw(RSS::Tree);
use strict;


sub new {
    my $class = shift;

    my $self = $class->SUPER::new(
        'http://www.giantitp.com/comics/oots.rss',
        'http://seanmcafee.name/rss/',
        'oots', 'Order of the Stick'
    );

    $self->set_cache(
        dir   => "$ENV{HOME}/.rss-cache",
        feed  => 60 * 10,
        items => 60 * 60 * 24 * 30,
    );

    return $self;

}

sub render {
    my ($self, $item) = @_;
    my ($image) = $item->page->findnodes('//img[contains(@src,"comics/images")]');

    return $image
        ? $item->page->absolutize($image, 'src')
        : $self->SUPER::render($item);

}

1;
