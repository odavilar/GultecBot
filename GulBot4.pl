#!/usr/bin/perl
#
# Program to do the obvious
#
use warnings;
use strict;

package MyBot;
use base qw(Bot::BasicBot);
use LWP::Simple;
require LWP;
require URI::Find;
require HTML::HeadParser;
#print "Mi Bot.\n";		# Print a message

sub said {
	my ($self, $message) = @_;
	if ($message->{body} =~ m/http/ ) 
	{
		my $finder = URI::Find->new(sub{
				my($uri, $orig_uri) = @_;
				if( head $uri ) {
					#print "$orig_uri is okay\n";
					$MyBot::laurl = $orig_uri;
					return $orig_uri;
				}
				else {
					#print "$orig_uri cannot be found\n";
					$MyBot::laurl = '0';
					return undef;
				}
			});
		$finder->find(\$message->{body});

	if($MyBot::laurl ne '0'){
		my $url = $MyBot::laurl;
		$MyBot::src = get($url);
		#print $MyBot::src;
		$MyBot::p = HTML::HeadParser->new;
		($MyBot::p)->parse($MyBot::src);
		$MyBot::elem = ($MyBot::p)->header('Title');
		return $MyBot::elem;
	}else{
		return undef;
	}
}else{
	return undef;
}
}

MyBot->new(
	server => "irc.freenode.net",
	port   => "6667",
	channels => ["#gultec"],

	nick      => "GultecBot",
	alt_nicks => ["Gultecb0t"],
	username  => "GultecBot",
	name      => "GultecBot",
)->run();
