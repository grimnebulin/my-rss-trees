package BoingBoing;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'boingboing',
    TITLE => 'Boing Boing',
    FEED  => 'http://boingboing.net/feed',
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
    my ($image) = $item->page->find('//div[%s]//img', 'featuredimage');
    my ($story) = $item->page->find('//div[@id="story"]');

    if ($story) {
        $self->remove($story, './/div[count(child::node())=1 and count(child::text())=1 and .="report this ad"]');
        $self->truncate($story, './/div[div[@id="mc_embed_signup"]]');
        $self->remove($story, './/h3[%s]', 'thetags');
        $self->remove($story, './/div[%s]//a[not(contains(@href,"boingboing"))]', 'share');
        if ($image) {
            if (grep { $_->attr('src') eq $image->attr('src') } $self->find($story, './/img')) {
                $image = undef;
            }
        }
    }

    return ($image, $story);

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
