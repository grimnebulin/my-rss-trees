package Schneier;

use RSS::Tree;
use strict;

our @ISA = qw(RSS::Tree);


sub new {
    my $class = shift;

    my $self = $class->SUPER::new(
        'http://www.schneier.com/blog/index.xml',
        'http://seanmcafee.name/rss/',
        'schneier', 'Schneier on Security'
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
    my ($h3) = $item->page->findnodes('//div[%s]/h3', 'indivbody');
    my @content;

    if ($h3) {
        for my $sibling ($h3->findnodes('following-sibling::*')) {
            my $tag = $sibling->tag;
            next if $tag ne 'p' && $tag ne 'blockquote';
            push @content, $sibling;
        }
    }

    return @content ? @content : $self->SUPER::render($item);

}

1;
