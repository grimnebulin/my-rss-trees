package FailBlog;

use URI;
use YouTubeInfo;
use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://feeds.feedburner.com/failblog',
    NAME  => 'failblog',
    TITLE => 'Fail Blog',
};


sub init {
    my $self = shift;
    $self->add(FailBlogVideo->new('failblogvideo', 'Fail Blog Video'));
}

sub test {
    my ($self, $item) = @_;
    return $item->title !~ /Mini Clip Show/
        && 0 == grep { /\bautoco/i } $item->categories;
}

sub render {
    my ($self, $item) = @_;

    $item->content->remove('//script');
    $item->content->remove('//p[.//img[contains(@src,"/completestore/")]]');
    $item->content->remove('//div[count(*)=0]');

    if (my ($bound) = $item->content->find(
        '//div[.//a[contains(@href,"cheezburger.com/tag/")]]'
    )) {
        my ($prev) = $bound->findnodes(
            'preceding-sibling::*[1][contains(normalize-space()," by:")]'
        );
        $bound->parent->splice_content(($prev || $bound)->pindex);
    }

    return;

}


{

package FailBlogVideo;

use parent qw(RSS::Tree::Node);

sub test {
    my ($self, $item) = @_;
    return $item->content->find('//param|//iframe')->size > 0;
}

sub render {
    my ($self, $item) = @_;

    $self->root->render($item);

    for my $iframe ($item->content->find('//iframe')) {
        next if $iframe->attr('src') !~ m|youtube\.com/embed/(\w+)|;
        my $duration = $item->cache->{$1} ||= do {
            my $d = _get_duration($1);
            defined $d ? $d : '?:??';
        };
        $iframe->replace_with(
            $self->new_element(
                'div', [ 'i', "Video duration: $duration" ],
            ),
            $self->new_element('div', $iframe),
        );
    }

    return;

}

sub _get_duration {
    my $vidid = shift;

    defined(my $duration = YouTubeInfo::duration($vidid))
        or return '??:??';

    my $seconds = $duration % 60;
    $duration = ($duration - $seconds) / 60;
    my $minutes = $duration % 60;
    $duration = ($duration - $minutes) / 60;
    my $hours = $duration;

    return sprintf '%d:%02d:%02d', $hours, $minutes, $seconds
        if $hours > 0;

    return sprintf '%02d:%02d', $minutes, $seconds;

}

}


1;
