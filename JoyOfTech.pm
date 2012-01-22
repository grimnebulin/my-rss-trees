package JoyOfTech;

use RSS::Tree;
use strict;

our @ISA = qw(RSS::Tree);


sub new {
    my $class = shift;

    my $self = $class->SUPER::new(
        'http://www.joyoftech.com/joyoftech/jotblog/index.xml',
        'http://seanmcafee.name/rss/',
        'joyoftech', 'Joy Of Tech'
    );

    $self->set_cache(
        dir   => "$ENV{HOME}/.rss-cache",
        feed  => 60 * 5,
        items => 60 * 60 * 24 * 30,
    );

    return $self;

}

sub render {
    my ($self, $item) = @_;

    return $self->SUPER::render($item)
        if 0 == (my ($thumbnail) = $item->body->findnodes('//a/img'));

    my ($image) = $self->download($thumbnail->parent->attr('href'))
                       ->findnodes('//img[contains(@alt,"Joy of Tech")]');
    if ($image) {
        $item->absolutize($image, 'src');
        $thumbnail->parent->replace_with($image);
    }

    return $item->body;

}


1;
