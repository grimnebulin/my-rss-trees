package Skepchick;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'skepchick',
    TITLE => 'Skepchick',
    FEED  => 'http://skepchick.org/feed/',
};


sub init {
    shift->match_creator('watson');
}

sub render {
    my ($self, $item) = @_;

    my ($video) = $item->page->find(
        '//article[%s]//div[iframe[contains(@src,"/www.youtube.com/")]]', 'post'
    );

    return (
        $video,
        $item->content->remove('//*[%s]', 'adsbygoogle')->guts,
    );

}


1;
