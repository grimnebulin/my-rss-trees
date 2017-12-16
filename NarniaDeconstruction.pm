package NarniaDeconstruction;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED => 'http://feeds.feedburner.com/AnaMardollsRamblings',
    NAME => 'narniadecon',
    TITLE => 'Narnia Deconstruction',
};

sub init {
    shift->match_title('narnia');
}


1;
