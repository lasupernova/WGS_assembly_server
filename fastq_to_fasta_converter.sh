#!/bin/bash 

for f in $1.fastq; do paste - - - - < $f | cut -f 1,2 | sed 's/^@/>/' | tr "\t" "\n" > $f.fasta; done

