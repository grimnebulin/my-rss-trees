package Scala;

use base qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://www.cakesolutions.net/teamblogs/feed/',
    NAME  => 'scala',
    TITLE => 'This Week In Scala',
};

sub render {
    my ($self, $item) = @_;
    return $item->page->find(
        '//div[%s]/child::*[not(self::script or self::iframe or self::div[%s])]',
        'entry-content', 'sharedaddy'
    );
}


1;
