package ledger;

use strict;
use warnings;
use lib 'lib';

use Dancer ':syntax';
use IPC::Run qw(run timeout);

our $VERSION = '0.1';

get '/' => sub {
  template 'index';
};

get '/a' => sub {
  template 'add_entry';
};

post '/a' => sub {
  # TODO add entry
};

get '/**' => sub {
  my ($args) = splat;

  my @params = ();
  my $params = params('query');

  foreach my $key (keys %$params) {
    my $switch = length $key == 1 ? "-$key" : "--$key";
    my $value = param $key;
    push @params, $switch;
    push @params, $value if $value;
  }

  my $command = [ ledger => @$args, @params ];
  run $command, '>', \my $output;

  if ($output) {
    template 'output', {
      command => join(' ', @$command),
      output => $output
    };
  } else {
    pass;
  }
};

1;
