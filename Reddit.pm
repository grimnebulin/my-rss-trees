package Reddit;

use parent qw(RSS::Tree);
use strict;

my $CODE = '//pre[count(*)=1]/code';


sub render {
    my ($self, $item) = @_;

    my %broken = map { $_->as_trimmed_text => $_ } $item->page->find($CODE);

    for my $code ($item->description->find($CODE)) {
        if (defined(my $broken = $broken{ $code->as_trimmed_text })) {
            $code->replace_with($broken);
        }
    }

    return;

}


1;
