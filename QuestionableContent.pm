package QuestionableContent;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME  => 'qc',
    TITLE => 'Questionable Content',
    FEED  => 'http://www.questionablecontent.net/QCRSS.xml',
    LIMIT => 10,
};


sub render {
    my ($self, $item) = @_;
    my ($img) = $item->page->find('//div[@id="comic"]//img') or return;
    return ($img, $item->page->find('//div[@id="news"]'));
}


1;
