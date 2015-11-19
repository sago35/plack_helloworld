use strict;
use warnings;
use Plack::Builder;
use Data::Printer;
use Data::Dumper;
use Plack::Request;
use Time::Moment;
use Path::Tiny;

my $p = path("data.txt");

my $app = sub {
    my $env = shift;


    my $html = <<HTML;
<a href="/post">post</a><p>
<hr>
HTML
    foreach my $line (reverse $p->lines) {
        my ($time, $name) = split /<>/, $line;
        $html .= <<HTML;
<dl>
    <dt>$time</dt>
    <dd>$name</dd>
</dl>
HTML
    }

    return [
        200,
        ['Content-Type' => 'text/html'],
        [$html],
    ];
};

my $post = sub {
    my $env = shift;
    my $req = Plack::Request->new($env);

    my $name = $req->param('name');
    my $time = Time::Moment->now();


    if (defined $name) {
        $p->spew(join "\n", $p->lines({chomp => 1}), "$time<>$name");

        return [
            302,
            ['Location' => '/'],
            [],
        ];
    } else {
        return [
            200,
            ['Content-Type' => 'text/html'],
            [<<HTML,
<form method="POST" action="/post">
<input name="name" value="">
<input type="submit">
</form>
HTML
],
        ];
    }
};

builder {
    mount "/post", => $post;
    mount "/", => $app;
}
