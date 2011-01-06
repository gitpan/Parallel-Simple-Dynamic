package Parallel::Simple::Dynamic;

use Class::Std;
use Class::Std::Utils;
use POSIX qw(ceil);
use Parallel::Simple qw( prun );

use warnings; 
use strict;

{
        my %list_of  		:ATTR( :get<list>   	     :set<list>   	   :default<[]>    :init_arg<list> );
        my %call_back		:ATTR( :get<call_back>       :set<call_back>       :default<''>    :init_arg<call_back> );
        my %num_of_cores	:ATTR( :get<num_of_cores>    :set<num_of_cores>    :default<''>    :init_arg<num_of_cores> );

	sub START {
	        my ($self, $ident, $arg_ref) = @_;
		return;
	}
	
	sub drun {
		my ( $self, $arg_ref ) = @_;
	
		my $parts        =  defined $arg_ref->{parts}	     ? $arg_ref->{parts}        : 2;
		my $list         =  defined $arg_ref->{list} 	     ? $arg_ref->{list}   	:[];
		my $call_back	 =  defined $arg_ref->{call_back}    ? $arg_ref->{call_back} 	:'';

		my @partitions = $self->partition( {parts => $parts, list => $list } );

		my ( $pindex, @prun );
		foreach my $partition ( @partitions ) {
		        my $prun = [ $call_back, ++$pindex, @$partition ];
			push @prun, $prun;
			}
		prun( @prun ) or die( Parallel::Simple::errplus() );

		}	
	
	sub partition {
		my ( $self, $arg_ref ) = @_;
		
		my $parts =  defined $arg_ref->{parts} ? $arg_ref->{parts} : 2;
		my $list  =  defined $arg_ref->{list}  ? $arg_ref->{list}  : [];
		my @results;
		my @segments = $self->calc_segments( {parts => $parts, list_length => scalar( @$list )} );
		#print "Segments: " . join( ', ', @segments ) . "\n";
		for ( my $i = 1; $i <= $parts; $i++ ) {
			my $start   = $segments[$i-1];
			my $end     = $segments[$i] - 1;
			my @segment = @$list[$start..$end];
			push @results, \@segment;
		}
		return @results;
	}
	
	sub calc_segments {
		my ( $self, $arg_ref ) = @_;
		
		my $parts        =  defined $arg_ref->{parts}	     ? $arg_ref->{parts}        : 2;
		my $list_length  =  defined $arg_ref->{list_length}  ? $arg_ref->{list_length}  :'';
		my @segments = (0);
		my $width   = $list_length / $parts;
		for ( my $i = 1; $i <= $parts; $i++ ) {
			$segments[$i] = ceil( ($i) * $width );
		}
		return @segments;
	}
}
1; # End of Parallel::Simple::Dynamic
__END__

=head1 NAME

Parallel::Simple::Dynamic - executes the block of program code in parallel on several processors 

=head1 VERSION

This document describes Parallel::Simple::Dynamic version 0.0.1

=head1 SYNOPSIS

	use Parallel::Simple::Dynamic;

	# A list of items
	my @list;
	
	# Creat a new object
	my $psd = Parallel::Simple::Dynamic->new();

	# Execute the call_back subroutine in 4 parallel processes 
	my @result = $psd->drun( { call_back => \&call_back, parts => 4, list => \@list } );

	exit;
	
=head1 DESCRIPTION

There are some problems in bioinformatics and other fields that can be separated into a number of parallel tasks 
with no dependency between them (embarrassingly parallel problem).  

Parallel::Simple::Dynamic is an object-oriented module that can be used for execution of this kind of tasks 
in parallel on multiple processor systems. This can remarkably reduce time of running the program and solving the problem. 

=head1 METHODS 

=over

=item B<drun>

Processes each segment of data-set in parallel on separate processor.
There are three properties of C<drun> method needs to be specified. I<list> is a set of data that needs to be processed, 
I<call_back> is a subroutine that needs to be executed on this set of data, and I<parts> is a number of processors what you want to use. 

=item B<partition>

Identifies the elements for each data-segment

=item B<calc_segments>

Splits the set of data into separate independent segments

=back

=head1 DEPENDENCIES 

	Class::Std;
	Class::Std::Utils;
	Parallel::Simple qw( prun );
	POSIX qw(ceil);

=head1 AUTHOR

Aleksandra Markovets, C<< <marsa@cpan.org> >>
Roger A Hall, C<< <rogerhall@cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-parallel-simple-dynamic at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 LICENSE AND COPYRIGHT

Copyright 2010 Aleksandra Markovets.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See F<http://dev.perl.org/licenses/ for more information>

=cut

