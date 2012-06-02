package DrDobbs;

use base qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://www.drdobbs.com/articles/rss',
    NAME  => 'drdobbs',
    TITLE => 'Dr. Dobb\'s',
};


sub render {
    my ($self, $item) = @_;
    my $page = $item->page;
    my @content;

    while ($page) {
        push @content, $page->findnodes(
            '//*[@id="IG_description" or @id="IG_main_image" or %s or %s or %s]',
            'byline', 'story-teaser', 'story'
        );
        my ($next) = grep { $_->as_trimmed_text =~ /\b next \b/xi }
            $page->findnodes('//div[%s]//a', 'nav1');
        $page = $next && $page->open($next->attr('href'));
        push @content, '<hr><div>Next page fetched automatically.</div><hr>'
            if $page;  # temporary
    }

    return @content;

}


1;
