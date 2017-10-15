use strict;
use warnings;
package Mojolicious::Plugin::Localizer;

use Mojo::Base 'Mojolicious::Plugin';

use Path::Tiny;

sub register {
    my ($self, $app, $conf) = @_;
    $app->helper('localize' => sub {
		     shift;
		     
		     my $dom = Mojo::DOM->new((shift)->()) ;
		     $dom->find('script, link')->each(sub {
							 my $s = shift; 
							 my $url = Mojo::URL->new($s->attr('src') || $s->attr('href'));
							 my $local = path('./static/' . $url->path)->absolute;
							 if (-s $local) {

							 } else {
							     $local->touchpath;
							     my $ua = Mojo::UserAgent->new;
							     my $res = $ua->get($url)->result;
							     if ($res->is_success)  {
								 $local->spew_raw($res->body)
							     }
							 }
							 if (0) {
							     if ($s->tag eq 'link') { $s->attr('href', '/' . $local->relative('.')) }
							     if ($s->tag eq 'script') { $s->attr('src', '/' . $local->relative('.')) }
							 }
						     });
		     return "$dom"
		 });
}

1;
