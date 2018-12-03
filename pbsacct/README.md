Torque accounting scripts
-------------------------

This directory contains a very simple accounting statistics tool
"pbsacct" for the Torque batch system (tested also with PBSPro 5.1.4).

The script "pbsreportmonth" is a convenient way to automatically
generate a monthly report for the previous month.

The latest version of this software may be downloaded from
ftp://ftp.fysik.dtu.dk/pub/Torque/

Thanks for feedback goes to:
   Jan-Frode Myklebust <janfrode@parallab.uib.no>

-------------------------------------------------------

User accounting summary utility
-------------------------------

Usage: 

   pbsacct [-g group-id | -G] <files>

where <files> are one or more daily record files (such as 20080725)
located in $PBSHOME/server_priv/accounting/
(PBSHOME is usually /var/spool/torque).

The optional argument "-g group-id" may be used to select 
only one UNIX group-id, whose accounting information will be shown.

The optional argument "-G" may be used to select groupwise accounting data,
which is typically wanted by management for monthly or annual reports.

A sample output is:

# pbsacct 200210??

Portable Batch System USER accounting statistics
------------------------------------------------

A total of 31 accounting files will be processed.
The first record is dated 10/01/2002, last record is dated 10/31/2002.

                          Wallclock          Average Average
Username    Group   #jobs      days  Percent  #nodes  q-days
--------    -----   ----- ---------  ------- ------- -------
   TOTAL        -    5365  14256.10   100.00    6.45    0.58
user0001     grp1     157   3054.13    21.42   15.36    3.23
user0002     grp1      96   1826.88    12.81   15.94    3.38
user0003     grp2     196   1057.19     7.42    5.28    0.28
user0004     grp1     480    892.48     6.26   11.43    0.17
user0005     grp1      47    835.92     5.86   15.56    0.92
user0006     grp1      90    685.39     4.81   13.80    0.08
user0007     grp1     125    672.25     4.72    4.13    1.61
user0008     grp1      94    659.45     4.63   10.75    0.15
user0009     grp2      81    604.45     4.24    4.17    0.22
user0010     grp1      45    540.53     3.79    7.95    0.39
...
(The usernames have been made anonymous here). 

--

We prefer to count wall-clock time in days rather than hours or seconds.

It should be noted that PBS records only the CPU-time spent
on the Master-node of parallel jobs.  The spawning of parallel
processes by, e.g., MPI is outside the control of PBS, and no
accounting of the Slave nodes is currently performed.
Also, when users run parallel jobs with the LAM-MPI,
the user processes detach themselves from the PBS process
group, and hence the measured CPU-time is usually zero.
Therefore, PBS' record of CPU-time is a useless quantity
in such cases.  The only reliable measure is actually the
Wall-time times the number of nodes. 

In the case of the Torque resource manager, if the MPI library has been
compiled with the Torque Task Manager, then CPU-time accounting may
be reliably reported from all Torque tasks.

The column "Average #nodes" is a weighted average of the number of
nodes used in parallel by the user's jobs. 

The column "Average q-days" is the average number of days
that the jobs spent in the queue while being eligible to run.
This shows how difficult it is for jobs to get CPU-time on
this system.

========================================================================


Monthly accounting summary utility
----------------------------------

The script "pbsreportmonth" is a convenient way to automatically
generate a monthly report for the previous month.  It may
be run on the first day of every month using crontab with
a line like this:

0 2 1 * * (cd <Report-directory>; /usr/local/bin/pbsreportmonth)

The accounting report may be mailed to the administrators
by uncommenting some lines at the end of the script.

-------------------------------------------------------

The helper script "pbsjobs" processes the raw accounting
files, looking for records with an "E" in the second field,
meaning a job that Ended.  The script extracts some fields
of interest, and prints out 1 line of relevant information
for each job.  This list of information is then summarized
by the pbsacct script.  

The PBS server records accounting information in the module 
src/server/accounting.c, wherein the explanation of the
various accounting fields may be learned.  This is also 
documented in the PBS External Reference Specification,
see the chapter on Batch Server Functions.

-------------------------------------------------------

Author: Ole Holm Nielsen
Department of Physics, Technical University of Denmark,
Building 307, DK-2800 Lyngby, Denmark.
E-mail: Ole.H.Nielsen@fysik.dtu.dk
