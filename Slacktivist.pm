package Slacktivist;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'slacktivist',
    TITLE => 'Slacktivist',
    FEED  => 'http://www.patheos.com/blogs/slacktivist/feed/',
};


sub init {
    shift->add(
        RSS::Tree::Node->new('leftbehind', 'Left Behind')
                       ->match_category('left behind')
    );
}

sub render {
    my ($self, $item) = @_;
    $self->wrap($_, 'div') for $item->content->find('//img');
    return;
}


1;
