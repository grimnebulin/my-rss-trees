package Snopes;

use base qw(RSS::Tree);
use strict;


sub new {
    my $class = shift;

    my $self = $class->SUPER::new(
        'http://www.snopes.com/info/whatsnew.rss',
        'http://seanmcafee.name/rss/',
        'snopes', 'Snopes'
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
    my @rendered = ($self->SUPER::render($item));

    my ($divider) = $item->page->findnodes('//img[contains(@src,"content-divider")]');

    if ($divider) {
        my $verdict = $divider->parent->right->as_text;
        my $para = HTML::Element->new_from_lol(['p', 'Verdict: ', ['b', $verdict]]);
        unshift @rendered, $para;
    }

    return @rendered;

}

1;
