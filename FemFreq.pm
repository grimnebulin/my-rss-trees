package FemFreq;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME     => 'femfreq',
    TITLE    => 'Feminist Frequency',
    FEED     => 'http://www.feministfrequency.com/feed/',
    AGENT_ID => 'Anything',
    EXTRA_HTTP_HEADERS => { Accept => '*/*' },
};


sub render {
    my ($self, $item) = @_;
    return $item->page->find('//div[%s]/p[not(@*)]', 'entry');
}


1;
