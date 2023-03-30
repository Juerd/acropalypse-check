#!/usr/bin/perl -w
use strict;

@ARGV or die "Usage: $0 PNGFILE...\nOutputs the file names of the PNG files with trailing data.";

FILE: while (@ARGV) {
    my $fn = shift;
    eval {
        no warnings 'exiting';

        open my $fh, "<", $fn;
        read $fh, my $magic, 8;
        $magic eq "\x89PNG\x0d\x0a\x1a\x0a" or next FILE;
        while (1) {
            read $fh, my $size_packed, 4;
            my $size = unpack "N", $size_packed;
            read $fh, my $ctype, 4;
            #print "[$ctype=$size]", tell($fh), "\n";
            seek $fh, $size + 4, 1;  # skip data + checksum
            last if $ctype eq "IEND";
            next FILE if eof $fh;
        }

        next FILE if eof $fh;
        my $extra = (-s $fn) - tell $fh;
        next FILE if $extra <= 4;
        print $fn, "\n";
    };
    warn "$fn: $@\n" if $@;
}
