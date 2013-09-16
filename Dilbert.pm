package Dilbert;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://feeds.feedburner.com/DilbertDailyStrip?format=xml',
    NAME  => 'dilbert',
    TITLE => 'Dilbert',
    KEEP_GUID => 1,
};


sub render {
    my ($self, $item) = @_;
    my ($img) = $item->page->find('//div[%s]/img', 'STR_Image') or return;
    $img->attr('onload', undef);  # Probably unnecessary.
    return $img;
}

sub uri_for {
    my ($self, $item) = @_;
    return $item->guid;
}

sub decode_response {
    my ($self, $response) = @_;
    return $response->decoded_content(alt_charset => 'utf-8');
}



1;
