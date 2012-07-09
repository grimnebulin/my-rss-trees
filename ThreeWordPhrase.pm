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
    return $item->page->find('//center/img');
}

# sub _images {
#     my $item = shift;
#     return map {
#         my $uri = $item->absolutize($_, 'src');
#         $uri->host =~ /threewordphrase/ ? $_ : ();
#     } $item->page->find('//img[@width > 500]');
# }


1;
