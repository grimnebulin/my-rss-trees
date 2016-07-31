package JoeMyGod;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'joemygod',
    TITLE => 'Joe.My.God',
    FEED  => 'http://www.joemygod.com/feed/',
    AGENT_ID => 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:47.0) Gecko/20100101 Firefox/47.0',
};


sub render {
    my ($self, $item) = @_;
    my @image = $item->page->find('//div[%s]//img', 'single-post-thumb');
    $_->attr('style', 'display: block') for @image;
    my $content = $self->SUPER::render($item);
    for my $p (reverse $content->find('//p')) {
        my $text = $p->as_trimmed_text;
        $p->detach, last if $text =~ /^The post / && $text =~ / appeared first on /;
    }
    return (@image, $content);
}


1;
