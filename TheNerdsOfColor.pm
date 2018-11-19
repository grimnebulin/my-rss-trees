package TheNerdsOfColor;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED => 'http://thenerdsofcolor.org/feed/',
    NAME => 'tnoc',
    TITLE => 'The NOC',
};

sub render {
    my ($self, $item) = @_;
    delete $item->{item}{entry}{enclosure};
    return;
}


1;
