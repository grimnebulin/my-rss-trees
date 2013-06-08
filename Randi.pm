package Randi;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'randi',
    TITLE => 'Randi Speaks',
    FEED  => 'http://www.randi.org/site/index.php?format=feed&type=rss',
};


sub test {
    my ($self, $item) = @_;
    return $item->author =~ /randi\@randi/;
}


1;
