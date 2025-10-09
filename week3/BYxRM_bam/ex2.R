library(tidyverse)
setwd("/Users/cmdb/qb25-answers/week3/BYxRM_bam")

#--------------------------------Allele Frequency-------------------------------
freq <- read_csv("AF.txt")

ggplot(data = freq, mapping = aes( x = Allele_Frequency)) +
  geom_histogram(bins = 11) +
  labs(
    y = "Frequency"
  ) 
# Question 2.1:
# Does it look as expected? Why or why not? 
# Bonus: what is the name of this distribution?

# It does look as expected because the segregates have 50% contribution from 
# each parent. This is a normal or bell curve distribution.

#-----------------------------------Read Depth----------------------------------
depth <- read_csv("DP.txt")

ggplot(data = depth, mapping = aes( x = Read_Depth)) +
  geom_histogram(bins = 21) +
  xlim(0,20) +
  labs(
    y = "Read_Depth"
  ) 
# Question 2.2:
# This plot represents the distribution of the read coverage across the variant 
# calls. It tells us how much sequencing coverage the variant calls have. This 
# is a left-skewed distribution which is expected because some regions have less
# reads because of G C content but most regions should have high read coverage.








