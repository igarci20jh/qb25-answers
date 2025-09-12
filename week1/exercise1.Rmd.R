library(tidyverse)

header <- c("chr", "start", "end", "count")
df_kc <-read_tsv("/Users/cmdb/qb25-answers/week1/hg19-kc-count1.bed", col_names = header)

ggplot(data = df_kc, 
       mapping = aes(x = start,
                     y = count)) +
  geom_line() +
  facet_wrap("chr")

ggsave("exercise1.png")
