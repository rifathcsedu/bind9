#!/bin/sh
#
# Copyright (C) 2000, 2001, 2003, 2004, 2007, 2012, 2013, 2016  Internet Systems Consortium, Inc. ("ISC")
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

SYSTEMTESTTOP=..
. $SYSTEMTESTTOP/conf.sh

#
# Do glue tests.
#

DIGOPTS="+norec -p ${PORT}"

status=0

echo_i "testing that a ccTLD referral gets a full glue set from the root zone"
$DIG $DIGOPTS @10.53.0.1 foo.bar.fi. A >dig.out || status=1
$PERL ../digcomp.pl --lc fi.good dig.out || status=1

echo_i "testing that we find glue A RRs we are authoritative for"
$DIG +norec @10.53.0.1 -p 5300 foo.bar.xx. a >dig.out || status=1
$PERL ../digcomp.pl xx.good dig.out || status=1

echo_i "testing that we find glue A/AAAA RRs in the cache"
$DIG +norec @10.53.0.1 -p 5300 foo.bar.yy. a >dig.out || status=1
$PERL ../digcomp.pl yy.good dig.out || status=1

echo_i "testing that we don't find out-of-zone glue"
$DIG $DIGOPTS @10.53.0.1 example.net. a > dig.out || status=1
$PERL ../digcomp.pl noglue.good dig.out || status=1

echo_i "exit status: $status"
[ $status -eq 0 ] || exit 1
