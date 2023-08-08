#!/usr/bin/bash
dirs="01-test-asm 02-test-c 03-test-conio-c 04-test-calling 05-snake"
for d in $dirs; do
        cd $d
        make
        cd ../
done
