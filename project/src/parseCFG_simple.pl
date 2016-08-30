#!/usr/bin/perl -w

use warnings;
use strict;

use Getopt::Long;
use Data::Dumper;
$Data::Dumper::Indent = 1;
# use GraphViz2;

$|=1;

# -----------------------------------------------------------------------------
# my $inFile = "/media/sf_ECE5534/VeriWork/SimpleUart/obj_dir/Vuart_990_final.tree";
my $inFile = shift || die "Please point to the correct AST dump.\n\n";
unless(-e $inFile) {
	die "$inFile doesn't exist. Please point to the correct AST dump.\n\n";
}

# Store the coverage point names as per their appearance in the source code (line#)
my %cNames=();
my @lines = `grep "1:2: COVERDECL" $inFile`;
chomp @lines;
my $cNum = $#lines;	# number of coverage points in this AST
foreach (0..$cNum){
	$lines[$_] =~ /{(.+?)}/;
	$cNames{$1} = $_;
}

$inFile =~ /\/V(\w+)_990/;
my $topname = $1;

print "Total coverage points in $topname: ".($cNum+1);
# -----------------------------------------------------------------------------


# open AST tree file for parsing
open FILE, "<$inFile" or die $!;

# init search parameters
my %coverCFG=();
my %parent=();
my $STARTLVL;

my $line=<FILE>;
while($line){
	# search for the beginning of the function
	# Each function represents a verilog always block
	# hence, each always block has its own CFG
	$line=<FILE> while($line && $line !~ /:\sCFUNC.*sequent__TOP__/);

	if($line){
		chomp $line;
		$line =~ /\s([^\s]+?):\sCFUNC/;
		my $func_scope_tag = $1;
		print "\nPARSING [$func_scope_tag] $line\n";

		# Initialize sub-graph level from the level of the current function
		my @items = split ':', $func_scope_tag;
		$STARTLVL = $#items;
		%parent=();
		$parent{$STARTLVL+1} = 'START';

		# Collect all coverage lines for the function and store it aside for recursive parsing
		while($line = <FILE>){
			chomp $line;
			$line=~/\s([\d:]+?):\s/;
			my $tag = $1;
			last if ($tag eq $func_scope_tag);

			# Look for statements that increment the coverage point and parse various attributes
			if($line=~/COVERINC/){
				# print "$line\n";
				# parse coverage point level from the tag
				my @items = split ':', $tag;
				my $currLvl =  $#items;
				my $parentLvl = $currLvl-1;

				while(!(defined $parent{$parentLvl})){
					--$parentLvl;
				}

				# parse the ID
				$line =~ /{(.+?)}/;
				my $node = $cNames{$1};
				print "$parent{$parentLvl}($parentLvl) --> $node($currLvl)\n";

				# Set the current node as the parent for the current level
				$parent{$currLvl} = $node;

				# Update the CFG hash with this parent-child edge
				$coverCFG{$parent{$parentLvl}}{$node}=1; 
			}
		}
	}
}
close FILE;

#  Close the CFG graph, i.e. make all leaf nodes terminate at a single exit point
foreach my $n1(keys %coverCFG){
	foreach my $n2 (keys %{$coverCFG{$n1}}){
		unless($coverCFG{$n2}) {
			$coverCFG{$n2}{'END'}=1;
		}
	}
}

# print "\n\n".Dumper(\%coverCFG);


# # -----------------------------------------------------------------------------
# # Store the CFG as an SVG for visual inspection
# my $graph = GraphViz2 -> new(
#                  edge   => {color => 'grey'},
#                  global => {directed => 1},
#                  node   => {shape => 'oval'},
#                 );

# $graph->add_node(name => 'START');
# $graph->add_node(name => 'END');
# foreach (0..$cNum){
# 	$graph->add_node(name => $_);
# }


# for my $parent (keys %coverCFG){
# 	for my $child (keys %{$coverCFG{$parent}}){
# 		$graph->add_edge(from => $parent, to => $child);
# 	}
# }

# my $output_file = "${topname}_CFG.svg";
# $graph -> run(format => "svg", output_file => $output_file);
# # -----------------------------------------------------------------------------

# Obtain all paths in the graph and store them as their traversal through coverage points
# For example we perform a full DFS and extract all paths.
# Then for each coverage point, we see which paths pass through it, and store it under it
our @allPaths=();
print "\n\nALL PATHS:\n";
get_paths('START', []);
print "\n\n";

# Now, for each coverage point, dump the path data into a file
# storage format
# (coverage point ID)
# (no. of paths)
# (no. of nodes) n1 n2 n3...

open oFILE, ">CFGPaths.rep" or die "Can't open CFGPaths.rep\n";
foreach my $cp (0..$cNum){
	my @paths = ();

	#  iterate through all paths
	foreach my $p (@allPaths){
		# See if the path traverses through the target coverage point
		if(grep {$_==$cp} @$p){
			push @paths, $p;
		}
	}

	my $nPaths = $#paths+1;

	print oFILE "$cp\n";
	print oFILE "$nPaths\n";
	foreach my $p (@paths){
		my @tp = @$p;
		print oFILE ($#tp+1);
		print oFILE " @tp\n";
	}
}
close oFILE;



print "\n\n";



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# METHODS
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# DFS based path collection
sub get_paths{
	my $parent = shift;
	my @currentPath = @{(shift)};

	# Add oneself to the path list
	if($parent =~ /\d/){
		push @currentPath, $parent;
	}

	# check if one is a terminal node
	unless($coverCFG{$parent}){
		push @allPaths, \@currentPath;
		print "@currentPath\n";
	} else {
		# Iterate through all children
		foreach my $child (keys %{$coverCFG{$parent}}){
			if($child eq 'END' || $parent eq 'START' || $child!=$parent){
				get_paths($child, \@currentPath) 
			}
		}
	}
}