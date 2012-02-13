package MyRssBase;

use base qw(RSS::Tree);
use strict;

use constant ITEM_CACHE_MINUTES => 60 * 24 * 30;


sub new {
    my $class = shift;
    my $self = $class->SUPER::new(
        scalar $class->FEED,
        undef,
        scalar $class->NAME,
        scalar $class->TITLE,
        cache => {
            dir   => "$ENV{HOME}/.rss-cache",
            feed  => 60 * 5,
            items => 60 * $class->ITEM_CACHE_MINUTES,
        }
    );
    $self->init;
    return $self;
}

sub init {
    # No-op.
}


1;
