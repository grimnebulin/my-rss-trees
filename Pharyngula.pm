package Pharyngula;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'pharyngula',
    TITLE => 'Pharyngula',
    FEED  => 'http://feeds.feedburner.com/freethoughtblogs/pharyngula',
    KEEP_GUID => 1,
};


sub init {
    shift->match_creator('pz');
}

sub render {
    my ($self, $item) = @_;
    my ($content) = $item->page->find('//div[%s]', 'entry-content') or return;
    $self->truncate($content, 'div[%s]', 'sharedaddy');
    return $content;
}


1;
