#get hg19.chrom.sizes
wget https://hgdownload.soe.ucsc.edu/goldenPath/hg16/bigZips/hg16.chrom.sizes

#make windows
bedtools makewindows -g hg16-main.chrom.sizes -w 1000000 > hg16-1mb.bed
bedtools intersect -c -a hg16-1mb.bed -b hg16-kc.bed > hg16-kc-count1.bed

#---------how many geen unique to each assembly-------
#How many genes in hg 19
wc -l hg19-kc.bed
    #80270 genes

#How many genes in hg19 not hg16
bedtools intersect -a hg19-kc.bed -b hg16-kc.bed -v | wc -l
    #42717 genes

#Why are some genes in hg19 but not hg16?
    #Some genes are in hg19 but not hg16 because hg16 is an older version.


#How many genes in hg 16
wc -l hg16-kc.bed
    #21365 genes

#How many genes in hg16 not hg19
bedtools intersect -a hg16-kc.bed -b hg19-kc.bed -v | wc -l
    #3460 genes

#Why are some genes in hg16 but not hg19?
    #Some genes are in hg16 but not hg19 because the coordinates may have 
    #changed when they were re-sequenced.
