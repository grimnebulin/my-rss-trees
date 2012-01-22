package PennyArcade;

use RSS::Tree;
use strict;

our @ISA = qw(RSS::Tree);


sub new {
    my $class = shift;

    my $self = $class->SUPER::new(
        'http://feeds.penny-arcade.com/pa-mainsite',
        'http://seanmcafee.name/rss/',
        'pennyarcade2', 'Penny Arcade'
    );

    $self->set_cache(
        dir   => "$ENV{HOME}/.rss-cache",
        feed  => 60 * 5,
        items => 60 * 60 * 24 * 30,
    );

    return $self;

}

sub render {
    my ($self, $item) = @_;

    if ($item->title =~ /^Comic:/) {
        my $image = _get_image($item)
            or return $self->SUPER::render($item);
        $item->absolutize($image, 'src');
        return $image;
    } elsif ($item->title =~ /^News/) {
        my ($seotitle) = $item->link =~ m|/([^/]+?)/?\z|
            or return $self->SUPER::render($item);
        my @content;
      POST:
        for my $post ($item->page->findnodes('//div[%s]', 'post')) {
            # for my $anchor ($post->findnodes('./div[%s]/div[%s]//a', 'heading', 'title')) {
            for my $anchor ($post->findnodes('./div[contains(concat(" ",normalize-space(@class)," ")," heading ")]/div[contains(concat(" ",normalize-space(@class)," ")," title ")]//a')) {
                my $href = $anchor->attr('href');
                if (substr($anchor->attr('href'), -length($seotitle)) eq $seotitle) {
                    @content = $post->findnodes('./p');
                    last POST;
                }
            }
        }
        return @content ? @content : $self->SUPER::render($item);
    } else {
        return $self->SUPER::render($item);
    }

}

sub _get_image {
    my $item = shift;
    return $item->page->findnodes(
        '//div[%s and %s]/img', 'post', 'comic'
    )->shift;
}


1;
