package ThisModernWorld;

use base qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://www.dailykos.com/user/Comics/rss.xml',
    NAME  => 'modernworld',
    TITLE => 'This Modern World',
};


sub test {
    my ($self, $item) = @_;
    return $item->author =~ /Tom Tomorrow/;
}


1;
