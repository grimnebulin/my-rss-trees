package YellowHearts;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED   => 'http://yellowheartscomic.tumblr.com/rss',
    NAME   => 'yellowhearts',
    TITLE  => 'Yellow Hearts',
    RENDER => [ '//article[%s]//img', 'post' ],
};


1;
