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
    for my $img ($item->page->find('//img[contains(@src,"/joyimages/")]')) {
        if ($img->attr('src') =~ /\d{4,}\.[^.]+\z/) {
            return $img;
        }
    }
    return;
}


1;
