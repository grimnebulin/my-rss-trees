package ToplessRobot;

use parent qw(MaybeLengthy);
use strict;

use constant {
    FEED  => 'http://www.toplessrobot.com/rss.xml',
    NAME  => 'toplessrobot',
    TITLE => 'Topless Robot',
};


sub get_body {
    my ($self, $page) = @_;
    my ($body) = $page->find('//div[%s or %s]', 'Entry_Body', 'Scribol') or return;
    $self->truncate($body, 'div[%s]', 'Tags');
    return $body;
}

sub abbreviate {
    my ($self, $item, $body) = @_;
    $self->truncate($body, './/div[@id="more"]');
    return $body;
}


1;
