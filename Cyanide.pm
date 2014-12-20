package Cyanide;

use URI;
use URI::QueryParam;
use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'cyanide',
    TITLE => 'Cyanide & Happiness',
    FEED  => 'http://feeds.feedburner.com/Explosm',
    AGENT_ID => 'Anything',
};

sub render {
    my ($self, $item) = @_;

    if ($item->title =~ /^short:/i
        and my ($video) = $item->page->find('//div[@id="videoPlayer"]//iframe')) {
        my $uri = URI->new($video->attr('src'));
        $uri->query_param_delete('autoplay');
        $video->attr('src', $uri);
        return $video;
    }

    my ($comic) = $item->page->find('//img[@id="main-comic"]');
    return $comic if $comic;

    return $item->page->find('//div[starts-with(@id,"post_message_")]');

}

1;
