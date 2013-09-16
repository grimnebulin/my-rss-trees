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

    if (my ($image) = $self->get($thumbnail->attr('href'))
                           ->find('//img[contains(@src,"joyimages")]')) {
        $thumbnail->postinsert($image->as_HTML);
        $thumbnail->replace_with($image);
    }

    return $item->description;

}


1;
