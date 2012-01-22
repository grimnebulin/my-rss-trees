package OnionAVClub;

use RSS::Tree;
use strict;

our @ISA = qw(RSS::Tree);

my @TV_I_WATCH = (
    'American Dad',
    'Archer',
    'South Park',
    'Big Bang Theory',
    'Dexter',
    'Beavis and Butt-Head',
    'Family Guy'
);

my @TV_I_IGNORE = (
    'Amazing Race',
    'X Factor',
    'The Office',
    'Scrubs',
    'Survivor',
    'Leverage',
    'Hell On Wheels',
    'Saturday Night Live',
    'The League',
    'Burn Notice',
    'Psyche',
    'The X Factor',
    'Glee',
    '2 Broke Girls',
    'Terra Nova'
);

sub new {
    my $class = shift;

    my $self = $class->SUPER::new(
        'http://www.avclub.com/feed/daily',
        'http://seanmcafee.name/rss/',
        'avclub', 'AV Club',
    );

    $self->set_cache(
        dir   => "$ENV{HOME}/.rss-cache",
        feed  => 60 * 5,
        items => 60 * 60 * 24,
    );

    OnionAVClub::Review
        ->new('greatjob', 'Great Job')
        ->title('Great Job')
        ->add_to($self);

    OnionAVClub::Review
        ->new('newswire', 'Newswire')
        ->title(': Newswire:')
        ->add_to($self);

    my $tv = OnionAVClub::Review
        ->new('tv', 'TV')
        ->title('^TV:')
        ->add_to($self);

    OnionAVClub::Review
        ->new
        ->titles('TV', @TV_I_IGNORE)
        ->add_to($tv);

    OnionAVClub::Review
        ->new('tv_i_watch', 'TV I Watch')
        ->titles('TV', @TV_I_WATCH)
        ->add_to($tv);

    OnionAVClub::Review
        ->new('films', 'Films')
        ->title('Movie Review')
        ->add_to($self);

    OnionAVClub::Review
        ->new('film', 'Film')
        ->title('^Film:')
        ->add_to($self);

    OnionAVClub::Review
        ->new('books', 'Books')
        ->title('^Books:')
        ->add_to($self);

    OnionAVClub::Review
        ->new('music', 'Music')
        ->title('^Music:')
        ->add_to($self);

    RSS::Tree::Node
        ->new('redmeat', 'Red Meat')
        ->title('Red Meat')
        ->add_to($self);

    RSS::Tree::Node
        ->new('geekery', 'Geekery')
        ->title('Gateways to Geekery')
        ->add_to($self);

    return $self;

}

sub render {
    my ($self, $item) = @_;

    return $self->SUPER::render($item) if $item->title !~ /: Wondermark:/;

    my ($image) = $item->page->findnodes('//div[%s]/img', 'image');

    return $image
        ? $item->page->absolutize($image, 'src')
        : $self->SUPER::render($item);

}

package OnionAVClub::Review;

our @ISA = qw(RSS::Tree::Node);

sub titles {
    my ($self, $prefix, @titles) = @_;
    my $title_re = join '|', map quotemeta, @titles;
    $self->title("^\Q$prefix\E: (?i:$title_re):");
}

sub render {
    my ($self, $item) = @_;

    my $grade = $item->page->findvalue(
        '//div[%s]/span[%s]', 'title-holder', 'grade'
    );

    my @show = map {
        $_->findnodes('./p|./ul|./ol|./blockquote')
    } $item->page->findnodes(
        '//div[%s and %s and %s]', 'article', 'body', 'article_body'
    );

    return (
        $grade ? "<p>Grade: <b>$grade</b></p>" : "",
        @show ? @show : $self->SUPER::render($item)
    );

}

1;
