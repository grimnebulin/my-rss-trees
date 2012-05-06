package ToplessRobot;

use base qw(MyRssBase);
use strict;

use constant {
    FEED  => 'http://www.toplessrobot.com/rss.xml',
    NAME  => 'toplessrobot',
    TITLE => 'Topless Robot',
};


sub render {
    my ($self, $item) = @_;
    my ($body) = $item->page->findnodes('//div[%s]', 'Entry_Body')
        or return;
    my ($tags) = $item->findnodes($body, 'child::div[%s]', 'Tags');
    $_->detach for $tags ? ($tags->right, $tags) : ();
    return $body;
}


1;
