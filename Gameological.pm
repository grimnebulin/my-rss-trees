package Gameological;

use base qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://gameological.com/feed/',
    NAME  => 'gameo',
    TITLE => 'Gameological',
};


sub init {
    my $self = shift;
    $self->add(Gameological::SawbuckGamer->new);
}

sub render {
    my ($self, $item) = @_;
    my ($content) = $item->page->find('//div[@id="main-content"]')
        or return;
    $_->detach for $content->findnodes(
        'child::*[@id="page-category" or @id="share" or ' .
        '@id="outbrain" or @id="comments"]'
    );
    return $content;
}

{

package Gameological::SawbuckGamer;

use base qw(RSS::Tree::Node);

sub new {
    return shift->SUPER::new('sawbuck', 'Sawbuck Gamer')
                ->match_title('Sawbuck Gamer');
}

*render = *Gameological::render;

}


1;
