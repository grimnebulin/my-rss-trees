package PennyArcade;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://feeds.penny-arcade.com/pa-mainsite',
    NAME  => 'pa',
    TITLE => 'Penny Arcade',
};


sub init {
    my $self = shift;
    $self->add(PennyArcade::NonComics->new('panews', 'Penny Arcade'));
}

sub render {
    my ($self, $item) = @_;
    my ($image) = $item->page->find('//div[@id="comicFrame"]//img');
    return $image ? $image : ();
}


package PennyArcade::NonComics;

use parent qw(RSS::Tree::Node);


sub test {
    my ($self, $item) = @_;
    return $item->title !~ /^Comic:/;
}

sub render {
    my ($self, $item) = @_;
    return $item->title =~ /^News/ ? $self->_get_news($item) : ();
}

sub _get_news {
    my ($self, $item) = @_;
    my ($seotitle) = $item->link =~ m|/([^/]+?)/?\z| or return;
    my @content;

    for my $post ($item->page->find('//div[%s]', 'post')) {
        for my $anchor ($self->find($post, './div[%s]/div[%s]//a', 'heading', 'title')) {
            my $href = $anchor->attr('href');
            if (substr($anchor->attr('href'), -length($seotitle)) eq $seotitle) {
                return $post->findnodes('.//p');
            }
        }
    }

    return;

}


1;
