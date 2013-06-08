package ToplessRobot;

use parent qw(RSS::Tree);
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
    my ($body) = $item->page->find('//div[%s]', 'Entry_Body') or return;

    $self->truncate($body, 'div[%s]', 'Tags');
    $self->truncate($body, './/div[@id="more"]') if _body_too_long($body);

    return $body;

}

sub _body_too_long {
    my $body = shift;
    return $body->findnodes('//img|//embed|//iframe')->size > $EMBED_LIMIT
        || length($body->as_trimmed_text) > $TEXT_LIMIT;
}


1;
