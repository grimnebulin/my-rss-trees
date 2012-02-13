package ThisModernWorld;

use base qw(MyRssBase);
use strict;

use constant {
    FEED  => 'http://www.dailykos.com/user/Comics/rss.xml',
    NAME  => 'modernworld',
    TITLE => 'This Modern World',
};

sub init {
    my $self = shift;
    $self->add(ThisModernWorld::Not->new);
}


package ThisModernWorld::Not;

use base qw(RSS::Tree::Node);

sub test {
    my ($self, $item) = @_;
    return $item->author !~ /Tom Tomorrow/;
}


1;
