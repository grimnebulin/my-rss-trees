package QuestionableContent;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'qc',
    TITLE => 'Questionable Content',
    FEED  => 'http://www.questionablecontent.net/QCRSS.xml',
};


sub render {
    my ($self, $item) = @_;
    my ($img) = $item->description->find('//img[contains(@src,"/comics/")]')
        or return;
    $img->parent->splice_content(0, $img->pindex) if $img->parent;
    return;
}


1;
