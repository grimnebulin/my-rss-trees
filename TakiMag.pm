package TakiMag;

use base qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://pipes.yahoo.com/pipes/pipe.run?_id=660d170d0107102bf1509321ab659d7e&_render=rss',
    NAME  => 'takimag',
    TITLE => 'Taki\'s Magazine',
};

sub render {
    my ($self, $item) = @_;
    my $page = $item->page;
    # print STDERR $page; exit;
    my @content;

    do {
        my ($post) = $page->findnodes('//div[@id="post"]');
        return @content if !$post;
        # my ($pag)  = $item->findnodes($post, 'child::div[%s]', 'pagination');
        # $pag->detach if $pag;
        push @content, $post->findnodes('child::*');
        $page = $page->follow('//div[%s]//a[contains(string(),"Next")]', 'pagination');
        # ($next) = $pag->findnodes('descendant::a[contains(string(),"Next")]');
        # $page = $next && $next->follow('attribute::href');
    } while $page;

    return @content;

}


1;
