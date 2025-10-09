#!/bin/bash

freebayes -f /Users/cmdb/qb25-answers/week2/genomes/sacCer3.fa -L bamListFile.txt --genotype-qualities -p 1 > unfiltered.vcf

vcffilter -f "QUAL > 20" -f "AN > 9" unfiltered.vcf > filtered.vcf

vcfallelicprimitives -kg filtered.vcf > decomposed.vcf

vcfbreakmulti decomposed.vcf > biallelic.vcf