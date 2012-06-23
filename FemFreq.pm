package FemFreq;

use base qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'femfreq',
    TITLE => 'Feminist Frequency',
    FEED  => 'http://www.feministfrequency.com/feed/',
};


sub render {
    my ($self, $item) = @_;
    return $item->page->findnodes('//div[%s]/p[not(attribute::*)]', 'entry');
}


1;
