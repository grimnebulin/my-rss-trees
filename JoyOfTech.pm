package JoyOfTech;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://www.joyoftech.com/joyoftech/jotblog/index.xml',
    NAME  => 'joyoftech',
    TITLE => 'Joy Of Tech',
    LIMIT => 5,
};


sub render {
    my ($self, $item) = @_;

    my ($thumbnail) = $item->description->find('//a[img]') or return;
    my $href = $thumbnail->attr('href');

    my $response = $self->agent->get($href);
    $response->is_success or return;
    my $page = $self->new_page($href, $response->decoded_content);

    if (my ($image) = $page->find('//img[contains(@src,"/cartoons/")]')) {
        $thumbnail->postinsert($image->as_HTML);
        $thumbnail->replace_with($image);
    }

    return $item->description;

}


1;
