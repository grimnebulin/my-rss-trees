package ThreeWordPhrase;

use RSS::Tree;
use strict;

our @ISA = qw(RSS::Tree);


sub new {
    my $class = shift;

    my $self = $class->SUPER::new(
        'http://www.threewordphrase.com/rss.xml',
        'http://seanmcafee.name/rss/',
        '3word', 'Three Word Phrase',
    );

    $self->set_cache(
        dir   => "$ENV{HOME}/.rss-cache",
        feed  => 60 * 5,
        items => 60 * 60 * 24 * 30 * 12,
    );

    return $self;

}

sub render {
    my ($self, $item) = @_;
    return (_images($item), '<br>', $self->SUPER::render($item));
}

sub _images {
    my $item = shift;
    return map {
        my $uri = $item->absolutize($_, 'src');
        $uri->host =~ /threewordphrase/ ? $_ : ();
    } $item->page->findnodes('//img[@width > 500]');
}

1;
