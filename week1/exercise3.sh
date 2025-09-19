#-------------command to test where there is any overlap--------
bedtools intersect -u -a nhek-active.bed -b nhek-repressed.bed

#-----command to find regions active in NHEK and in NHLF--------

bedtools intersect -c -a nhek-active.bed -b nhlf-active.bed  > nhek-in-nhlf-count.bed
#14013 features

#-----command to find regions active in NHEK and repressed in NHLF--------

bedtools intersect -c -a nhek-active.bed -b nhlf-repressed.bed  > nhek-not-nhlf-count.bed
#14013 features
#the numbers do not add up to the original number of line in nhek-active.bed

#-----command to only report one feature per overlap--------
bedtools intersect -c -a nhek-active.bed -b nhlf-active.bed  > nhek-in-nhlf-count-unique.bed

#-----commands to see effects of using arguments--------
    ## -f 1
    bedtools intersect -f 1 -a nhek-active.bed -b nhlf-active.bed

    ## -F 1
    bedtools intersect -F 1 -a nhek-active.bed -b nhlf-active.bed

    ## -f 1 -F 1
    bedtools intersect -f 1 -F 1 -a nhek-active.bed -b nhlf-active.bed
    #The relationship between NHEK and NHLF chromatin state becomes more and more strict. 
    #The last command reduces the overlap the most.

#-----commands to identify different types of regions--------
    ## Active in NHEK, Active in NHLF
    bedtools intersect -a nhek-active.bed -b nhlf-active.bed > active_nhek_active_nhlf.bed

    ## Active in NHEK, Repressed in NHLF
    bedtools intersect -a nhek-active.bed -b nhlf-repressed.bed > active_nhek_repressed_nhlf.bed

    ## Repressed in NHEK, Repressed in NHLF
    bedtools intersect -a nhek-repressed.bed -b nhlf-repressed.bed > repressed_nhek_repressed_nhlf.bed

#-------Chromatin state across all nine condions---------------------
    ## active-active
        #nhlf- the region is mostly repressed with some parts labelled as poised promoter
        #nhek- the region is mostly a poised promoter with some repressed patches
        #k562- the region is mostly repressed with small part labelled as poised promoter
        #HUVEC- mostly poised promoter with some repressed parts
        #HSMM- mix of poised promoter, repressed and weak promoter
        #HepG2- poised promoter with some active promoter, weak enhanver , and weak promoter
        #H1hESC- mostpy poised promoter
        #GM12878- mostly repressed some parts are poised promoter

    ## active-repressed
        #nhlf- the region is mostly repressed with some parts labelled as poised promoter
        #nhek- the region is partly labelled as poised promoter and repressed
        #k562- the region is mostly repressed with small part labelled as poised promoter and insulator
        #HUVEC- mostly poised promoter with some repressed parts, some weak promoter, some weak enhancer
        #HSMM- mix of poised promoter, repressed and weak promoter but mostly repressed
        #HMEC- partly repressed and poinsed promoter with parts weak enhancer and weak promoter
        #HepG2- mix od weak txn, weak enhancer, active promoter, poised promoter, and strong enhancer
        #H1hESC- mostly poised promoter with some repressed
        #GM12878- mostly repressed some parts are poised promoter

    ## repressed-repressed
        #nhlf- the region is mostly repressed with some parts labelled as poised promoter, and weak promoter
        #nhek- the region is partly labelled as poised promoter and repressed
        #k562- the region is mostly repressed with small part labelled as poised promoter and insulator
        #HUVEC- mostly poised promoter with some repressed parts, some weak promoter, some weak enhancer
        #HSMM- mix of poised promoter, repressed and weak promoter but mostly repressed
        #HMEC- partly repressed and poised promoter with parts weak enhancer and weak promoter
        #HepG2- mix od weak txn, weak enhancer, active promoter, poised promoter, and strong enhancer
        #H1hESC- mostly poised promoter with some repressed
        #GM12878- mostly repressed some parts are poised promoter

