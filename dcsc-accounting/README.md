
==================================
DCSC accounting package for Torque
==================================

This is the DCSC accounting package that can be used at DCSC installations
that use the Torque (or PBS) resource manager.  The final output format is not
specific to any batch system, and could be used by other batch systems such as
LoadLeveler.

A number of conventions for file formats have been decided by the DCSC system
administrators so that they suit all of the DCSC centers.

The description of the DCSC accounting setups was decided on a DCSC system
administrator meeting in Odense on Jan. 13, 2009.  Please see the file
Forbrugsgrafer.pdf for the summary presented to the board of DCSC in Jan. 2009.

Author of this package: Ole Holm Nielsen at DCSC/DTU,
E-mail Ole.H.Nielsen@fysik.dtu.dk

================
Package contents
================

1. The top-level directory contains the general site-specific configurations.

2. The subdirectory pbsacct/ contains the scripts that generate daily 
   accounting record database files from the Torque/PBS resource manager.
   Similar scripts for other batch systems still need to be written, however,
   the database file formats should be invariant across all DCSC sites.

3. The subdirectory dailygraphs/ contains the scripts that generate daily
   accounting graphs (using rrdtool) from the accounting record database files.

4. System load statistics scripts the Torque/Maui batch
   system is also in the subdirectory dailygraphs/.

Some path locations of files are configurable in the scripts, but the scripts
have been configured with /var/spool/dcsc as the top-level directory where we
keep databases, configurations etc.

Installation
============

Please see the INSTALL file.

General site-specific setups
============================

config script
-------------

Configures file locations and variables for all of the scripts listed below.
You MUST configure this file so that it suits your own environment.

site script
-----------

This auxiliary script defines the DCSC operations center name and the machine name,
to be included in other scripts.

grants file
-----------

This file contains an ASCII-format database with all grants used to buy machine
resources, be they DCSC or funded by other resources.  The file format is defined as:

Grant-name:Group:Sponsor:Personal-name:E-mail:Number-CPU-cores:Disk-capacity:Start-date:End-date:Comments

The command showgrants prints the grants file in a slightly more readable format.

Remarks:
* Comment lines that begin with "#" are skipped (initial white space is ignored).
* Grant-name: Unique identifier of the grant.
* Group: The research group or institute (may have 1 or more grants).
       UNIX groups should be mapped to this Group name using the unixgroups file.
* Sponsor: DCSC or LOCAL (or ...).
* Personal-name: Full name of the grant holder.
* E-mail: E-mail of the grant holder.
* Number-CPU-cores: How many CPU cores were installed based upon this grant.
* Disk-capacity: How many Terabytes of disk capacity (type float) were installed
       based upon this grant.
* Start-date: The operational starting date of hardware based upon this grant.
* End-date: The operational ending date of hardware based upon this grant.

Example:
HDW-2006-KWJ:DTU-CAMD:DCSC:Karsten W. Jacobsen:kwj@fysik.dtu.dk:548:3.5:1/9/2006:1/9/2009:Kommentarer

NOTE 1: When a DCSC grant expires (after 3 years), the machine may continue to be operated
as a LOCAL resource.  In this case a new grant of the type LOCAL must be created,
starting at the end date +1 of the DCSC grant.
All other LOCAL resources may also be defined alongside DCSC resources.

NOTE 2: A special grant named "Free-Resources" with Group=DCSC-FR must exist,
since this is the special DCSC 10% of the total designated as Free Resources. 
We set the Number-CPU-cores=0 for this grant, but the Disk-capacity is set to the actual
space allocated to such users.

unixgroups file
---------------

This file maps UNIX group names to DCSC grant holder Group names as defined in the
grants file. The format is defined as:

UNIX-group:DCSC-groupname

Example:

campvip:DTU-CAMD
mek:DCSC-FR

NOTE: A special DCSC-groupname called "NOGROUP" is used to contain all those
UNIX-groups that are NOT listed in the unixgroups file.  This may happen,
for example, if a UNIX-group has been deleted because it is no longer relevant.

PBS/Torque daily accounting scripts
===================================

For the case of daily PBS/Torque accounting data, please refer to the files in
the pbsacct/ subdirectory.

