#!/usr/bin/perl

use CGI qw/:standard/;

$default_period = "daily";

# Read the 'site' file
if (open(S, "site")) {
  while(<S>) {
    chomp;
    next if /^\s*(|#.*)$/; 
    if (/^\s*DCSC_SITE\s*=\s*(.*[^ ])\s*$/) {
      ($DCSC_SITE = $1) =~ s/"//g;
    } elsif (/^\s*MACHINE\s*=\s*(.*[^ ])\s*$/) {
      ($MACHINE = $1) =~ s/"//g;
    } elsif (/^\s*CHARSET\s*=\s*(.*[^ ])\s*$/) {
      ($CHARSET = $1) =~ s/"//g;
    }
  }
  close(S);
} 
else {
  # Some reasonable defaults if no site-file is found
  $DCSC_SITE = 'DCSC';
  $CHARSET = 'iso-8859-1';
  $MACHINE = '';
}
$CHARSET = 'iso-8859-1' if ! $CHARSET;
$DCSC_SITE = 'DCSC' if ! $DCSC_SITE;
$mach = ($MACHINE ? $MACHINE . '_' : '');

# Read the '$MACHINE.grants' database
if (open(G, "$MACHINE.grants")) {
  while(<G>) {
    chomp;
    @gfield = split(/:/);
    $PI{$gfield[1]} = $gfield[3];
    $BS{$gfield[1]} = $gfield[9];
  }
  close(G);
}

$selected_period = (param('period') ? param('period') : $default_period );
@periods = ("daily", "weekly", "monthly", "yearly");

print header(-charset=>"$charset"),
      start_html(-title=>"$DCSC_SITE"),
      start_form,
      "Select view: &nbsp;\n",
      radio_group(-name=>'period',
                         -default=>"$default_period",
                         -values=>[@periods]),
      "&nbsp; &nbsp;",
      submit('Show'),
      p,
      "\n";

print "<h1>Machine $MACHINE</h1>\n";
chomp(@machine = `ls ${mach}system*.png`);
print "<table>\n";
$file = $mach . "system." . $selected_period . ".png";
if ( grep($file, @machine) ) {
    print "  <tr>\n",
          "    <td><img src='$file'>\n",
          "    <td> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $selected_period statistics\n",
          "  </tr>\n";
}
print "</table>\n";

if ($selected_period ne "daily") {            # we don't have daily graphs for groups
  print "<h1>Usage of groups</h1>\n";
  print "<table>\n";
  chomp(@images = `ls *.png`);                # which png's do we have?   
  for $png (@images) {
    next if $png =~ /_system/;               # skip system graphs
    ($group = $png) =~ s/^$mach([^\.]+)\..*/\1/;   # extract group name from graph-file
    $shown_groups{$group}++;                  # this is 'uniq'
    next if $shown_groups{$group} > 1;        # in perl...
    $file = $mach . $group . "." . $selected_period . ".png"; 
    if ( grep($file, @images) ) {
          print "<tr>\n  <td> <img src='$file'>\n",
                "  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $selected_period statistics for $PI{$group}\n",
                "</tr>\n";
    }
  }
  print "</table>\n";
}

print end_form,
      end_html;
#

