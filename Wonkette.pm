package Wonkette;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'wonkette',
    TITLE => 'Wonkette',
    FEED  => 'http://wonkette.com/feed/rss',
};


sub render {
    my ($self, $item) = @_;

    my ($content) = $item->page->find('//div[%s]', 'entry-content') or return;
    $self->truncate($content, './/div[@id="post-supplement"]');
    $self->remove($content, './/div[contains(@id,"-ad-")]');

    my ($tag) = $item->page->find('//div[%s]/a', 'primary_tag');
    $tag = $self->new_element('h3', $tag->as_trimmed_text) if $tag;

    if (my ($img) = $content->findnodes('.//*[self::img or self::iframe]')) {
        if (my ($parent) = $img->findnodes('parent::a')) {
            $parent->replace_with($img);
        }
        $self->wrap($img, 'div');
        if (my $title = $img->attr('title', undef)) {
            $img->postinsert(
                $self->new_element('div', [ 'i', $title ])
            );
        }
    }

    return ($tag, $content->content_list);

}


1;
