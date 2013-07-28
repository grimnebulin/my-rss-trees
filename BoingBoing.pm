package BoingBoing;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'boingboing',
    TITLE => 'Boing Boing',
    FEED  => 'http://feeds.boingboing.net/boingboing/iBag',
};


sub init {
    shift->add(
        RSS::Tree::Node->new('bbcd', 'Cory Doctorow')->match_creator('Doctorow')
    );
}

sub render {
    my ($self, $item) = @_;
    return $item->content->truncate('//img[@width="1" or @height="1"]');
}


1;
