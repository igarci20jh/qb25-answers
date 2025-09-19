#-----------------bedtools command for most SNPs-----------
bedtools intersect -a hg19-kc.bed -b snps-chr1.bed -c | sort -k7,7nr | head -n 1
#coordinates: chr1	10003532	10045556

#Systematic name: NM_001297778.1
#the human readable name is NMNAT1
#Position: chr1:10002981-10045556
#size: 3796
#exon count: 5

#This may have the most snps because of it's size or it may just be well studied.

#--------which SNPs lie within vs outside of a gene---------

#make subset
bedtools sample -i snps-chr1.bed -n 20 -seed 42 > snps-subset.bed

#sort subset of SNPs
bedtools sort -i snps-subset.bed > snps-sorted.bed

#sort hg19
bedtools sort -i hg19-kc.bed > hg19-kc-sorted.bed

#closest/break ties
bedtools closest -a snps-sorted.bed -b hg19-kc-sorted.bed -d -t first > snps-close.bed

#How many SNPs are inside a gene?
#15

#What is the range of distances for the ones outside a gene?
# 1664-22944