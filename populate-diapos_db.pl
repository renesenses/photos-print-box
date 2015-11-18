#!/usr/bin/perl

# Usage  perl -w populate_diapos-db.pl [ box event sub ]

# Description : Script to populate PHOTOS databases from csv

use DBI;
#use strict;
use warnings;

use Text::CSV_XS qw( csv );

use DiaposApp::Schema;
use Data::Dumper;

#use File::Slurp;
use File::Find;
use File::Basename;

# CSV HEADERS
# 'BOX_NO;EVENT_NO;EVENT_YEAR;EVENT_MONTH;EVENT_NAME;NB_DIAPOS;SUB_RANGE;SUB_DEB;SUB_FIN;SUB_NAME'

##########################################################################################
# CONST
##########################################################################################
my $sep = ";";

##########################################################################################
# VARS
##########################################################################################


my $csv = "/Users/bertrand/MY_GITHUB/photos-print-box/db/csv_4_d3.csv";

#my $data_aofh;

#set 'database' => File::Spec->catfile(getcwd(),'db/diapos.db');


#$dbh = DBI->connect($data_source, $username, $password);

##########################################################################################
# SUBS (Unused)
##########################################################################################

sub connect_db {

    my $dbh = db->connect("dbi:SQLite:dbname=".setting('database')) or
        die;
 
    return $dbh;
}

sub init_db {
    my $db = connect_db();
    my $schema = read_file('./db/cr_diaposdb_v0.2.sql');
    $db->do($schema) or die $db->errstr;
}

##########################################################################################
# MAIN
##########################################################################################


print "start populate program  ...\n";

# read csv input file

#my $DATA_HASH = csv (in => $csv, headers => "auto", sep_char => $sep, encoding => "utf8");   # as array of hash

my $DATA_HASH = csv (in => $csv, headers => "auto", sep_char => $sep);   # as array of hash


#print "Debug DATA_HASH : ",Dumper($DATA_HASH);

my $schema = DiaposApp::Schema->connect('dbi:SQLite:dbname=/Users/bertrand/MY_GITHUB/photos-print-box/db/diapos.db');
#my $schema = db->connect('dbi:SQLite:$databse');

#print "Debug schema : ",Dumper($schema);


# DEBUG : OK
#	foreach my $box ( @{ $DATA_HASH } ) {
#		print "BOX_NO : ", $box->{BOX_NO},"\n";
#	}
	

# Build %DATA

my %BOX;

foreach my $line ( @{ $DATA_HASH } ) {

	print $line->{BOX_NO},"\t",$line->{EVENT_NO},"\t",$line->{SUB_NAME},"\n";

	if ( !($BOX{$line->{BOX_NO}}) ){
	#	 New box
		$BOX{$line->{BOX_NO}}++;
		$BOX{$line->{BOX_NO}}{$line->{EVENT_NO}}++;
		if ( defined($line->{SUB_NAME}) ) { $BOX{$line->{BOX_NO}}{$line->{EVENT_NO}}{$line->{SUB_NAME}}++; };
	}
	elsif ( !($BOX{$line->{BOX_NO}}{$line->{EVENT_NO}}) ) {
		$BOX{$line->{BOX_NO}}{$line->{EVENT_NO}}++;
		if ( defined($line->{SUB_NAME}) ) { $BOX{$line->{BOX_NO}}{$line->{EVENT_NO}}{$line->{SUB_NAME}}++; };
	}
	else {
		if ( defined($line->{SUB_NAME}) ) { $BOX{$line->{BOX_NO}}{$line->{EVENT_NO}}{$line->{SUB_NAME}}++; };
	} 
}

print Dumper(%BOX);

		
=begin comment	
#	BOX_NO;EVENT_NO;EVENT_YEAR;EVENT_MONTH;EVENT_NAME;NB_DIAPOS;SUB_RANGE;SUB_DEB;SUB_FIN;SUB_NAME

	foreach my $box ( sort (keys $DATA_HASH{BOX_NO}) ) {
		# populate box table 
		#push my @box_rec, [$DATA_HASH{$box}->{BOX_NO},$DATA_HASH{$box}->{box_name}];
		push my @box_rec, [$DATA_HASH{$box}->{BOX_NO},undef]
		$schema->populate('box', [ [qw/box_id box_name/], @box_rec ]);
		foreach my $event (keys $DATA_HASH{$box}->{EVENT_NO} # TO BE SORTED ...
			# populate event table 
			push my @event_rec, [	$DATA_HASH{$box}->{BOX_NO},
									$DATA_HASH{$box}->{EVENT_NO},
									$DATA_HASH{$box}->{EVENT_YEAR},
									$DATA_HASH{$box}->{EVENT_MONTH},
#									$DATA_HASH{$box}->{NB_DIAPOS} # CHECK NB_DIAPOS IN DB
								];
			$schema->populate('event', [ [qw/box_id event_id evant_year event_month event_name/], @event_rec ]);
			foreach my $sub (keys $DATA_HASH{$box}->{sub_name} # TO BE SORTED ... BY MY SUB_RANGE SUB
				# populate sub table 
				push my @sub_rec, [	$DATA_HASH{$box}->{box_id},
									$DATA_HASH{$box}->{event_id},
									$DATA_HASH{$box}->{sub_range},
									$DATA_HASH{$box}->{sub_name}];
				$schema->populate('sub', [ [qw/box_id event_id sub_range sub_name/], @sub_rec ]);						
			}
		}	
	}	

=end comment
=cut