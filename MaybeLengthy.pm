package MaybeLengthy;

use List::Util;

use parent qw(RSS::Tree);
use strict;

use constant {
    EMBED_LIMIT => 3,
    TEXT_LIMIT  => 2000,
};


sub render {
    my ($self, $item) = @_;
    my @body = $self->get_body($item->page) or return;
    return $self->abbreviate($item, @body) if $self->body_too_long(@body);
    return $self->postrender($item, @body);
}

sub abbreviate {
    return;  # default rendering
}

sub postrender {
    my ($self, $item, @body) = @_;
    return @body;
}

sub body_too_long {
    my ($self, @body) = @_;
    return 1 if $self->EMBED_LIMIT < List::Util::sum(
        map { scalar(() = $_->find_by_tag_name('img', 'embed', 'iframe')) } @body
    );
    return 1 if $self->TEXT_LIMIT < List::Util::sum(
        map { length($_->as_trimmed_text) } @body
    );
    return;
}


1;
