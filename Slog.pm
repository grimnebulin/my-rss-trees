package Slog;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://feeds.thestranger.com/stranger/slog',
    NAME  => 'slog',
    TITLE => 'Savage Slog',
};


sub test {
    my ($self, $item) = @_;
    return $item->creator =~ /savage/i;
}

sub render {
    my ($self, $item) = @_;
    return $item->page->find('//div[%s]', 'postBody');
}


1;
