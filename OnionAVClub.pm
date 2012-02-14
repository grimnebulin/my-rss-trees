package OnionAVClub;

use HTML::Element;
use base qw(MyRssBase);
use strict;

use constant {
    FEED  => 'http://www.avclub.com/feed/daily',
    NAME  => 'avclub',
    TITLE => 'AV Club',
    ITEM_CACHE_MINUTES => 60 * 24,
};

my @TV_I_WATCH = (
    'American Dad',
    'Archer',
    'South Park',
    'Big Bang Theory',
    'Dexter',
    'Beavis and Butt-Head',
    'Family Guy',
    'Deep Space',
);

my @TV_I_IGNORE = (
    'Amazing Race',
    'X Factor',
    'The Office',
    'Scrubs',
    'Survivor',
    'Survivor (Classic)',
    'Leverage',
    'Hell On Wheels',
    'Saturday Night Live',
    'The League',
    'Burn Notice',
    'Psyche',
    'The X Factor',
    'Glee',
    '2 Broke Girls',
    'Terra Nova',
    'American Idol',
    'Seinfeld',
    'Top Chef',
    'Touch',
    'Alias',
    'Remodeled',
);


sub init {
    my $self = shift;

    $self->add(
        OnionAVClub::Node
            ->new('savagelove', 'Savage Love')
            ->match_title('Savage Love:'),

        OnionAVClub::Node
            ->new('greatjob', 'Great Job')
            ->match_title('Great Job'),

        OnionAVClub::Node
            ->new('newswire', 'Newswire')
            ->match_title(': Newswire:'),

        OnionAVClub::Node
            ->new('tv', 'TV')
            ->match_title('^TV:')
            ->add(
                OnionAVClub::Node
                    ->new
                    ->match_titles('TV', @TV_I_IGNORE),

                OnionAVClub::Node
                    ->new('tv_i_watch', 'TV I Watch')
                    ->match_titles('TV', @TV_I_WATCH),
            ),

        OnionAVClub::Node
            ->new('games2', 'Games')
            ->match_title('^Games:'),

        OnionAVClub::Node
            ->new('films', 'Films')
            ->match_title('Movie Review'),

        OnionAVClub::Node
            ->new('film', 'Film')
            ->match_title('^Film:'),

        OnionAVClub::Node
            ->new('books', 'Books')
            ->match_title('^Books:'),

        OnionAVClub::Node
            ->new('music', 'Music')
            ->match_title('^Music:'),

        OnionAVClub::RedMeat
            ->new('redmeat', 'Red Meat')
            ->match_title('Red Meat'),

        OnionAVClub::Node
            ->new('geekery', 'Geekery')
            ->match_title('Gateways to Geekery'),

        OnionAVClub::Node
            ->new('wondermark', 'Wondermark')
            ->match_title('Wondermark'),

    );

}

sub _render_article {
    my ($self, $item) = @_;

    my ($byline) = $item->page->findnodes('//div[%s]', 'byline');

    my ($image) = $item->page->findnodes('//div[%s]/img', 'image');

    my $grade = $item->page->findvalue(
        '//div[%s]/span[%s]', 'title-holder', 'grade'
    );

    my @content = $item->page->findnodes(
        '//div[%s and %s and %s]/*[self::p or self::ul or self::ol or self::blockquote]',
        'article', 'body', 'article_body'
    );

    return (
        $image  ? $self->new_element('p', $image) : (),
        $byline ? $self->new_element('p', $byline->as_text) : (),
        defined $grade && $grade =~ /[[:alpha:]]/
            ? $self->new_element('p', 'Grade: ', ['b', $grade])
            : (),
        @content ? @content : $self->SUPER::render($item)
    );

}

sub render {
    my ($self, $item) = @_;
    return $self->_render_article($item) if $item->title !~ /: Tolerability Index/;
    return ($item->page->findnodes('//div[%s]/img', 'image'))[0];
}


package OnionAVClub::Node;

use base qw(RSS::Tree::Node);

*render = *OnionAVClub::_render_article;

sub match_titles {
    my ($self, $prefix, @titles) = @_;
    my $title_re = join '|', map quotemeta, @titles;
    $self->match_title("^\Q$prefix\E:.*(?i:$title_re):");
}


package OnionAVClub::RedMeat;

use base qw(RSS::Tree::Node);

sub render {
    my ($self, $item) = @_;
    return ($item->page->findnodes('//div[%s]/img', 'image'))[0];
}


1;
