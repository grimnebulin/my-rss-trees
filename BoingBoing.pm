package BoingBoing;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'boingboing',
    TITLE => 'Boing Boing',
    FEED  => 'http://feeds.boingboing.net/boingboing/iBag',
};


sub init {
    shift->add(
        RSS::Tree::Node->new('bbcd', 'Cory Doctorow')
            ->match_creator('Doctorow'),
        BoingBoing::TomTheDancingBug
            ->new('tombug', 'Tom the Dancing Bug')
            ->match_category('comic'),
    );
}

sub render {
    my ($self, $item) = @_;

    my ($post) = $item->page->find(
        '//div[@id="main-page" or @id="post" or %s]', 'post'
    ) or return;

    $self->remove($post, './/div[starts-with(@id,"ad_")]');
    $self->remove($post, './/div[@id="sidebar"]');
    $self->truncate($post, './/div[@id="metadataBox"]');
    $self->truncate($post, 'div[%s]/*[not(%s and %s)]',
                    'sharebutton-topbar', 'sharebutton', 'comments');

    $self->_unalign_wide_image($item, $_)
        for $self->find($post, './/img[@align and @src]');

    return $post;

}

sub _unalign_wide_image {
    my ($self, $item, $img) = @_;
    my $uri   = $item->page->absolute_uri($img->attr('src'));
    my $width = $item->cache->{$uri} ||= $self->_get_image_width($uri) || -1;
    if ($width > 300) {
        $img->attr('align', undef);
        $self->wrap($img, 'div');
    }
}

sub _get_image_width {
    require Image::Size;
    my ($self, $uri) = @_;
    my $response = $self->agent->get($uri);
    return if !$response->is_success;
    return (Image::Size::imgsize(\$response->decoded_content))[0];
}

{

package BoingBoing::TomTheDancingBug;

use parent qw(RSS::Tree::Node);

sub render {
    my ($self, $item) = @_;
    my ($img) = $item->page->find('//div[@id="main-page"]/img') or return;
    return (
        $self->new_element('div', $img),
        $self->render_default($item),
    );
}

}


1;
