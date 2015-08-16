package OnionAVClub;

use parent qw(RSS::Tree);
use strict;

use constant {
    FEED  => 'http://feeds.theonion.com/avclub/daily',
    NAME  => 'avclub',
    TITLE => 'AV Club',
    KEEP_ENCLOSURE => 0,
    AUTORESOLVE => 'follow',
};

my @TV_I_WATCH2 = (
    [ 'amdad'  , 'American Dad'                    ],
    [ 'archer' , 'Archer'                          ],
    [ 'bigbang', 'Big Bang Theory'                 ],
    [ 'bob'    , 'Bob.s Burgers', q(Bob's Burgers) ],
    # [ 'got'    , 'Game of Thrones'                 ],
    [ 'at'     , 'Adventure Time'                  ],
    [ 'walking', 'Walking Dead'                    ],
    [ 'sunny'  , 'Always Sunny'                    ],
    # [ 'southpark', 'South Park' ],
    # [ 'community', 'Community' ],
    [ 'gravityfalls', 'Gravity Falls' ],
);

my @TV_I_WATCHED = (
    'Batman: The Animated Series',
    'Babylon 5',
    'The Simpsons .Classic',
);


sub init {
    my $self = shift;
    my $N = 'OnionAVClub::Node';

    $self->add(
        $N->new('savagelove', 'Savage Love')->match_title('Savage Love:'),
        $N->new('greatjob', 'Great Job')->match_title('Great Job'),
        $N->new('newswire', 'Newswire')->match_title('^(?i:newswire):'),
        $N->new('geekery', 'Geekery')->match_title('Gateways to Geekery'),
        $N->new2('tv', 'TV')->add(
            $N->new('tv_i_watch', 'TV I Watch')
              ->match_title(_all_titles(@TV_I_WATCHED)),
            map $N->new($$_[0], $$_[2] || $$_[1])->match_title($$_[1]),
                @TV_I_WATCH2,
        ),
        $N->new('comics', 'Comics Panel')
            ->match_title('Comics Panel|Big Issues'),
        $N->new2('film')->add(
            $N->new('films', 'Films')->match_title('Movie Review'),
        ),
        $N->new2('books'),
        $N->new2('music'),
        $N->new2('comedy')->add(
            $N->new->match_title('Podcast Episode'),
        ),
        $N->new2('games'),
    );

}

sub render_article {
    my ($self, $item) = @_;

    my ($byline) = $item->page->find('//div[%s]', 'byline');

    my ($image) = $item->page->find(
        '//div[%s]//div[%s]//img', 'article-image', 'image'
    );

    my $alt = $image->attr('alt') if $image;

    my ($grade) = $item->page->find(
        '//div[%s]//div[%s and %s]', 'meta', 'grade', 'letter'
    );

    my ($content) = $item->page->find('//section[%s]', 'article-text');

    if ($content) {
        $self->remove($content, 'div[%s]', 'sharetools');
        $content = $self->new_element('div', $content->content_list);
        my $template;
        for my $script ($item->page->find('//script[not(@src)]')) {
            if (join("", $script->content_list) =~ /IMAGE_URL *= *"([^"]+)"/) {
                $template = $1;
                last;
            }
        }
        if (defined $template) {
            for my $div ($self->find($content, './/div[%s and @data-type="image" and @data-image-id and @data-crop]', 'onion-image')) {
                my %var = (
                    id => join(
                        '/', "", $div->attr('data-image-id') =~ /.{1,4}/gs
                    ),
                    crop => $div->attr('crop'),
                    width => '640',
                    'format' => $div->attr('data-format') || 'jpg',
                );
                (my $src = $template) =~
                    s/\{\{(id|crop|width|format)\}\}/$var{$1}/g;
                $div->delete_content;
                $div->push_content([ 'img', { src => $src } ]);
            }
        }
    }

    return (
        $image  && $self->new_element('p', $image),
        $alt    && $self->new_element('p', [ 'i', $alt ]),
        $byline && $self->new_element('p', $byline->as_text),
        $grade  && $grade->as_trimmed_text =~ /([[:alpha:]][-+]?)/ &&
            $self->new_element('p', 'Grade: ', [ 'b', $1 ]),
        $content ? $content : $self->SUPER::render($item),
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

{

package OnionAVClub::Node;

use parent qw(RSS::Tree::Node);

sub new2 {
    my ($class, $type, $title) = @_;
    return $class->new($type, $title || ucfirst $type)->has_class($type);
}

sub has_class {
    my ($self, $class) = @_;
    $self->{test} = sub {
        my $item = shift;
        my $c = $item->cache->{class} ||= do {
            my ($c) = $item->page->find('/html/body/@class');
            'x' . (defined $c ? $c->getValue : "");
        };
        return substr($c, 1) =~ /\b\Q$class\E\b/;
    };
    return $self;
}

}


1;
