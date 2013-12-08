package DrDobbs;

use URI;
use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://www.drdobbs.com/articles/rss',
    NAME  => 'drdobbs',
    TITLE => 'Dr. Dobb\'s',
};


sub render {
    my ($self, $item) = @_;
    my $page  = $item->page;
    my $count = 0;
    my @content;

    while ($page) {
        $page->remove('//div[%s]', 'article-resources');
        my $xpath   = '//*[@id="IG_description" or @id="IG_main_image" or %s]';
        my @classes = qw(story);
        if (++$count == 1) {
            substr($xpath, -1, 0, ' or (self::p and %s) or %s');
            push @classes, qw(byline story-teaser);
        }
        push @content, $page->find($xpath, @classes);
        my ($next) = grep { $_->as_trimmed_text =~ /\b next \b/xi }
            $page->find('//div[%s]//a', 'nav1');
        $page = $next && do {
            my $u = URI->new_abs($next->attr('href'), ???);
            my $response = $self->agent->get($u);
        $page = $next && $page->get($next->attr('href'));
        push @content, '<hr>' if $page;
    }

    return @content;

}


1;
