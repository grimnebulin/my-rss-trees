package Oglaf;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'oglaf',
    TITLE => 'Oglaf',
    FEED  => 'http://www.reddit.com/domain/oglaf.com/.rss',
    LIMIT => 5,
    AGENT_ID => 'Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/60.0',
};


sub render {
    my ($self, $item) = @_;

    my ($link) = $item->page =~ m|"url":"(https://www\.oglaf\.com/[^"]+)"| or return;
    my $uri = $item->page->absolute_uri($link);
    my $response = $self->agent->get($uri);
    my $page = $self->new_page($uri, $response->decoded_content);

    my ($img) = $page->find('//img[@id="strip"]') or return;
    my $title = $img->attr('title', undef);
    my $alt   = $img->attr('alt');

    $item->set_link($link);

    return (
        $img,
        defined $title ? $self->new_element('div', [ 'i', $title ]) : (),
        defined $alt   ? $self->new_element('div', [ 'i', $alt   ]) : (),
    );


}


1;
