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
        RSS::Tree::Node->new('sawbuck', 'Sawbuck Gamer (Other)')
                       ->match_title('Sawbuck Gamer')
                       ->add(
            IosGames->new('sawbuckios', 'Sawbuck Gamer (iOS)')
        ),
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


{

package IosGames;

use parent qw(RSS::Tree::Node);

sub test {
    my ($self, $item) = @_;
    my $ios = $item->cache->{is_ios} ||= do {
        my ($meta) = $item->page->find('//p[%s]', 'metadata');
        $meta && $meta->as_trimmed_text =~ /iP/ ? 'yes' : 'no';
    };
    return $ios eq 'yes';
}

}

1;
