package Oglaf;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'oglaf',
    TITLE => 'Oglaf',
    FEED  => 'http://www.reddit.com/domain/oglaf.com/.rss',
    LIMIT => 5,
};


sub render {
    my ($self, $item) = @_;

    my ($comic) = $item->page->find(
        '//div[%s]//a/@href[contains(.,"oglaf.com")]', 'entry'
    ) or return;

    my $href = $comic->getValue;

    if ($href =~ m|oglaf.com/comic/|) {
        return $self->new_element('img', { src => $href });
    }

    my $resp = $self->agent->post($href, { over18 => 'y' });
    $resp->is_success or return;

    my $page  = $self->new_page($href, $resp->decoded_content) or return;
    my ($img) = $page->find('//img[@id="strip"]') or return;
    my $title = $img->attr('title', undef);
    my $alt   = $img->attr('alt');

    return (
        $img,
        defined $title ? $self->new_element('div', [ 'i', $title ]) : (),
        defined $alt   ? $self->new_element('div', [ 'i', $alt   ]) : (),
    );


}


1;
