package WhatIf;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'whatif',
    TITLE => 'What If',
    FEED  => 'http://what-if.xkcd.com/feed.atom',
};

sub render {
    my ($self, $item) = @_;
    for my $ref ($item->description->find('//span[%s]', 'ref')) {
        if (my ($block) = $self->find($ref, 'ancestor::*[self::div or self::p]')) {
            $block->push_content(
                $self->new_element(
                    'div',
                    { style => 'font-size: smaller' },
                    $ref->clone
                )
            );
            $self->remove($ref, '*[%s]', 'refbody');
        }
    }
    return;
}


1;
