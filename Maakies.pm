package Maakies;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'maakies',
    TITLE => 'Maakies',
    FEED  => 'http://www.maakies.com/?feed=rss2',
};


sub render {
    my ($self, $item) = @_;
    my ($link) = $item->content->find('//a[img][count(*)=1]') or return;
    return $self->new_element('img', { src => $link->attr('href') });
}


1;
