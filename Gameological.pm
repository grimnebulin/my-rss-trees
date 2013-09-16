package Gameological;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://gameological.com/feed/',
    NAME  => 'gameo',
    TITLE => 'Gameological',
};


sub init {
    my $self = shift;
    $self->add(
        RSS::Tree::Node->new('sawbuck', 'Sawbuck Gamer')->match_title('Sawbuck Gamer')
    );
}

sub render {
    my ($self, $item) = @_;
    my ($content) = $item->page->find('//div[@id="main-content"]')
        or return;
    $self->remove(
        $content,
        '*[@id="page-category" or @id="share" or ' .
        '@id="outbrain" or @id="comments"]'
    );
    return $content;
}


1;
