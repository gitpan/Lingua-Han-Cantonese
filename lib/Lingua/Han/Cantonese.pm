package Lingua::Han::Cantonese;

use warnings;
use strict;
use vars qw($VERSION);
$VERSION = '0.01';

use Encode;
use File::Spec;

sub new {
	my $class = shift;
	my $dir = __FILE__; $dir =~ s/\.pm//o;
	-d $dir or die "Directory $dir nonexistent!";
	my $self = { '_dir_' => $dir, @_ };
	unless ($self->{'format'}) { $self->{'format'} = 'gb2312'; }
	my %ct;
	my $file = File::Spec->catfile($self->{'_dir_'}, 'Cantonese.dat');
	open(FH, $file)	or die "$file: $!";
	while(<FH>) {
		my ($uni, $ct) = split(/\s+/);
		$ct{$uni} = $ct;
	}
	close(FH);
	$self->{'ct'} = \%ct;
	return bless $self => $class;
}

sub han2Cantonese {
	my ($self, $hanzi) = @_;
	
	$hanzi = decode ( $self->{'format'} , $hanzi); # decode it
	my @code = map { uc sprintf("%x",$_) } unpack ("U*",$hanzi);

	my @result;
	foreach my $code (@code) {
		my $value = $self->{'ct'}->{$code};
		if (defined $value) {
			$value =~ s/\d//isg unless ($self->{'tone'});
		} else {
			# if it's not a Chinese, return original word
			$value = pack("U*", hex $code);
		}
		push @result, lc $value;
	}
	
	return wantarray ? @result : join('', @result);

}

1;
__END__

=head1 NAME

Lingua::Han::Cantonese - Retrieve the Cantonese(GuangDongHua) of Chinese character(HanZi).

=head1 SYNOPSIS

  use Lingua::Han::Cantonese;
  
  # if the format of your script is gb2312, default
  my $h2p = new Lingua::Han::Cantonese();
  print $h2p->han2Cantonese("我"); # ngo
  
  # if the format of your script is utf-8
  my $h2p = new Lingua::Han::Cantonese(format => 'utf8');
  print $h2p->han2Cantonese("我"); # ngo
  my @result = $h2p->han2Cantonese("爱你"); # @result = ('ngoi', 'nei');
  
  # we can set the tone up
  my $h2p = new Lingua::Han::Cantonese(format => 'utf8', tone => 1);
  print $h2p->han2Cantonese("我"); #ngo5
  my @result = $h2p->han2Cantonese("爱你"); # @result = ('ngoi3', 'nei5');
  print $h2p->han2Cantonese("林道"); #lam4dou3
  print $h2p->han2Cantonese("I love 余瑞华 a"); #i love jyu4seoi6waa4 a

=head1 DESCRIPTION

Retrieve the Cantonese(GuangDongHua) of Chinese character(HanZi).

=head1 RETURN VALUE

Usually, it returns its Cantonese/spell. It includes more than 20,000 words (from Unicode.org Unihan.txt, version 4.1.0).

if not(I mean it's not a Chinese character), returns the original word;

=head1 OPTION

=over 4

=item format => 'utf8|gb2312'

If you are in 'Unicode Editing' mode, plz set this to utf8, otherwise('ASCII Editing') use the default.

=item tone => 1|0

default is 0. if tone is needed, plz set this to 1.

=back

=head1 SEE ALSO

L<Unicode::Unihan>, L<Lingua::Han::PinYin>

=head1 AUTHOR

Fayland Lam, C<< <fayland at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-lingua-han-cantonese at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Lingua-Han-Cantonese>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Lingua::Han::Cantonese

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Lingua-Han-Cantonese>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Lingua-Han-Cantonese>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Lingua-Han-Cantonese>

=item * Search CPAN

L<http://search.cpan.org/dist/Lingua-Han-Cantonese>

=back

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2005 Fayland Lam, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut