#!/bin/bash

# Install the DCSC accounting tools

# DCSC top-level directory
DCSCDIR=/var/spool/dcsc

echo Copy configuration files to $DCSCDIR
mkdir -p $DCSCDIR
cp config site $DCSCDIR  # Edit paths and names in these files first !
cp unixgroups grants $DCSCDIR  # Edit these files first !
mkdir -p $DCSCDIR/accounting $DCSCDIR/dailygraphs

# Define file locations at this site
. $DCSCDIR/config

echo Copy scripts to $BINDIR
cp showgrants $BINDIR
( cd pbsacct; cp pbsjobs pbsacctdcsc pbsacctdcsc.cron2 pbsacctdcsc.load $BINDIR )
cp dailygraphs/rrd* $BINDIR

echo Now you may create database records for old accounting files by: pbsacctdcsc.load
