package ToplessRobot;

use base qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://www.toplessrobot.com/rss.xml',
    NAME  => 'toplessrobot',
    TITLE => 'Topless Robot',
};

my $EMBED_LIMIT = 3;

my $TEXT_LIMIT = 2000;


sub render {
    my ($self, $item) = @_;
    my ($body) = $item->page->findnodes('//div[%s]', 'Entry_Body') or return;
    my ($tags) = $item->findnodes($body, 'child::div[%s]', 'Tags');
    $_->detach for $tags ? ($tags->right, $tags) : ();

    if ($body->findnodes('//img|//embed|//iframe')->size > $EMBED_LIMIT ||
        length($body->as_trimmed_text) > $TEXT_LIMIT) {
        my ($more) = $body->findnodes('//div[@id="more"]');
        $_->detach for $more ? ($more->right, $more) : ();
    }

    return $body;

}


1;
