package KnowYourMeme;

use parent qw(RSS::Tree);
use strict;

use constant {
    NAME     => 'knowyourmeme',
    TITLE    => 'Know Your Meme',
    FEED     => 'http://knowyourmeme.com/memes.rss',
    AGENT_ID => 'Anything',
};

sub render {
    my ($self, $item) = @_;

    my ($refs) = $item->description->find('//div[%s]', 'references') or return;
    my %ref;

    for my $para ($self->find($refs, 'p[starts-with(@id,"fn")]')) {
        $self->remove($para, 'sup');
        $ref{ $para->attr('id') } = $para;
    }

    $refs->detach;
    $item->description->truncate('//h2[string()="External References"]');

    for my $link ($item->description->find('//a[starts-with(@href,"#fn")]')) {
        my $id = substr $link->attr('href'), 1;
        if (exists $ref{$id}) {
            $link->replace_with('[', $ref{$id}->content_list, ']');
        }
    }

    return;

}


1;
