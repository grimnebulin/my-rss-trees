package Geekologie;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://feeds.feedburner.com/geekologie/iShm',
    NAME  => 'geekologie',
    TITLE => 'Geekologie',
};


sub render {
    my ($self, $item) = @_;

    $item->description->remove(
        '//p[descendant::a[contains(@href,"doubleclick")]]|//img[@height="1"]'
    );

    my @guts = $item->description->guts;

    if (@guts) {
        $guts[0] = $self->new_element('div', $guts[0]);
    }

    if (my @categories = $item->categories) {
        unshift @guts, $self->new_element(
            'div', { style => 'font-size: smaller' }, join ' | ', @categories
        );
    }

    return @guts;

}


1;
