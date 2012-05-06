package ThreeWordPhrase;

use base qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://www.threewordphrase.com/rss.xml',
    NAME  => '3word',
    TITLE => 'Three Word Phrase',
};


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
