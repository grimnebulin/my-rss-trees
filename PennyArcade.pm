package PennyArcade;

use base qw(MyRssBase);
use strict;

use constant {
    FEED  => 'http://feeds.penny-arcade.com/pa-mainsite',
    NAME  => 'pennyarcade2',
    TITLE => 'Penny Arcade',
};


sub render {
    my ($self, $item) = @_;

    if ($item->title =~ /^Comic:/) {
        my ($image) = $item->page->findnodes('//div[%s and %s]/img', 'post', 'comic');
        return $image ? $image : ();
    } elsif ($item->title =~ /^News/) {
        return _get_news($item);
    }

    return;

}

sub _get_news {
    my $item = shift;
    my ($seotitle) = $item->link =~ m|/([^/]+?)/?\z| or return;
    my @content;

    for my $post ($item->page->findnodes('//div[%s]', 'post')) {
        for my $anchor ($post->findnodes('./div[contains(concat(" ",normalize-space(@class)," ")," heading ")]/div[contains(concat(" ",normalize-space(@class)," ")," title ")]//a')) {
            my $href = $anchor->attr('href');
            if (substr($anchor->attr('href'), -length($seotitle)) eq $seotitle) {
                return $post->findnodes('./p');
            }
        }
    }

    return;

}


1;
