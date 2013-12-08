package OnionAVClub;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://feeds.theonion.com/avclub/daily',
    NAME  => 'avclub',
    TITLE => 'AV Club',
    KEEP_ENCLOSURE => 0,
};

my @TV_I_WATCH2 = (
    [ 'amdad'  , 'American Dad'                    ],
    [ 'bigbang', 'Big Bang Theory'                 ],
    [ 'ds9'    , 'Deep Space Nine'                 ],
    [ 'bob'    , 'Bob.s Burgers', q(Bob's Burgers) ],
    # [ 'got'    , 'Game of Thrones'                 ],
    [ 'korra'  , 'Legend of Korra'                 ],
    [ 'at'     , 'Adventure Time'                  ],
    # [ 'sixfeet', 'Six Feet Under'                  ],
    [ 'walking', 'Walking Dead'                    ],
    [ 'sunny'  , 'Always Sunny'                    ],
    [ 'southpark', 'South Park' ],
);

my @TV_I_WATCHED = (
    'Batman: The Animated Series',
    'Babylon 5',
    'The Simpsons .Classic',
);


sub init {
    my $self = shift;
    my $N = 'RSS::Tree::Node';

    $self->add(
        # $N->new->match_title('Gameological Society'),
        $N->new('savagelove', 'Savage Love')->match_title('Savage Love:'),
        $N->new('greatjob', 'Great Job')->match_title('Great Job'),
        $N->new('newswire', 'Newswire')->match_title(': Newswire:'),
        $N->new('tv_i_watch', 'TV I Watch')
            ->match_title(_all_titles(@TV_I_WATCHED)),
        (map $N->new($$_[0], $$_[2] || $$_[1])->match_title($$_[1]), @TV_I_WATCH2),
        $N->new('tv', 'TV')->match_title('^TV:'),
        $N->new('films', 'Films')->match_title('Movie Review'),
        $N->new('film', 'Film')->match_title('^(?:Film|DVD):'),
        $N->new('comics', 'Comics Panel')
            ->match_title('Comics Panel|Big Issues'),
        $N->new('books', 'Books')->match_title('^Books:'),
        $N->new('music', 'Music')->match_title('^Music:'),
        $N->new('geekery', 'Geekery')->match_title('Gateways to Geekery'),
        $N->new('comedy', 'Comedy')->match_title('^Comedy:')->add(
            $N->new->match_title('Podcast Episode'),
        ),
    );

}

sub render_article {
    my ($self, $item) = @_;

    my ($byline) = $item->page->find('//div[%s]', 'byline');

    my ($image) = $item->page->find('//div[%s or %s]/img', 'image', 'review_image');

    my $alt = $image->attr('alt') if $image;

    my ($grade) = $item->page->find(
        '//div[%s]/span[%s]', 'title-holder', 'grade'
    );

    my @content = $item->page->find(
        '//div[%s]/*[self::p or self::ul or self::ol or self::blockquote or self::hr]',
        'article_body'
    );

    return (
        $image  && $self->new_element('p', $image),
        $alt    && $self->new_element('p', [ 'i', $alt ]),
        $byline && $self->new_element('p', $byline->as_text),
        $grade  && $grade->as_text =~ /([[:alpha:]][-+]?)/ &&
            $self->new_element('p', 'Grade: ', [ 'b', $1 ]),
        @content ? @content : $self->SUPER::render($item),
    );

}

sub render_image {
    my ($self, $item) = @_;
    return ($item->page->find('//div[%s]/img', 'image'))[0];
}

sub render {
    my ($self, $item) = @_;

    for my $elem ($item->page->find('//*[starts-with(@id,"yui_")]')) {
        $elem->replace_with($elem->content_list);
    }

    return $item->title =~ /: Tolerability Index/
        ? $self->render_image($item)
        : $self->render_article($item);
}

sub _all_titles {
    return '(?:' . join('|', @_) . ')\b';
}


1;
