library(tidyverse)
library(ggplot2)

setwd("/Users/cmdb/qb25-answers/week11")

coverage_df <- read.table("coverage.txt", header = FALSE)
colnames(coverage_df) <- c("coverage")

xs_df <- read.table("coverage_values.txt", header = FALSE)
colnames(xs_df) <- c("xs")

poisson_df <- read.table("poisson_estimates.txt", header = FALSE)
colnames(poisson_df) <- c("poisson")

normal_df <- read.table("normal_estimates.txt", header = FALSE)
colnames(normal_df) <- c("normal")

dist_df <- data.frame(
  xs = xs_df$xs,
  poisson = poisson_df$poisson,
  normal = normal_df$normal
)

Total <- nrow(coverage_df)       # total number of positions
bin_width <- 1               # histogram bin width

poisson_counts <- dist_df$poisson * Total
normal_counts  <- dist_df$normal * Total * bin_width

dist_df$poisson <- poisson_counts
dist_df$normal  <- normal_counts

graph <- ggplot() +
  
  # Histogram of coverage
  geom_histogram(
    data = coverage_df,
    aes(x = coverage),
    binwidth = 1,
    fill = "lightsteelblue1",
    color = "black",
    boundary = 0
  ) +
  
  # Poisson distribution (line)
  geom_line(
    data = dist_df,
    aes(x = xs, y = poisson, color = "Poisson"),
    size = 1
  ) +
  
  # Normal distribution (dashed line)
  geom_line(
    data = dist_df,
    aes(x = xs, y = normal, color = "Normal"),
    size = 1,
    linetype = "dashed"
  ) +
  
  labs(
    title = "Genome Coverage Distribution",
    x = "Coverage",
    y = "Frequency",
    color = "Distributions"
  ) +
  scale_color_manual(values = c(
    "Poisson" = "limegreen",
    "Normal" = "mediumorchid"
  )) +
  theme_minimal(base_size = 14)
print(graph)

ggsave("ex1_3x_cov.png")
#------------------------------Step 1.5-----------------------------------------
coverage_df2 <- read.table("coverage2.txt", header = FALSE)
colnames(coverage_df2) <- c("coverage")

xs_df2 <- read.table("coverage_values2.txt", header = FALSE)
colnames(xs_df2) <- c("xs")

poisson_df2 <- read.table("poisson_estimates2.txt", header = FALSE)
colnames(poisson_df2) <- c("poisson")

normal_df2 <- read.table("normal_estimates2.txt", header = FALSE)
colnames(normal_df2) <- c("normal")

dist_df2 <- data.frame(
  xs = xs_df2$xs,
  poisson = poisson_df2$poisson,
  normal = normal_df2$normal
)

Total <- nrow(coverage_df2)       # total number of positions
bin_width <- 1               # histogram bin width

dist_df2$poisson <- dist_df2$poisson * Total
dist_df2$normal  <- dist_df2$normal * Total * bin_width

graph2 <- ggplot() +
  
  # Histogram of coverage
  geom_histogram(
    data = coverage_df2,
    aes(x = coverage),
    binwidth = 1,
    fill = "lightsteelblue1",
    color = "black",
    boundary = 0
  ) +
  
  # Poisson distribution (line)
  geom_line(
    data = dist_df2,
    aes(x = xs, y = poisson, color = "Poisson"),
    size = 1
  ) +
  
  # Normal distribution (dashed line)
  geom_line(
    data = dist_df2,
    aes(x = xs, y = normal, color = "Normal"),
    size = 1,
    linetype = "dashed"
  ) +
  
  labs(
    title = "Genome Coverage Distribution x10",
    x = "Coverage",
    y = "Frequency",
    color = "Distributions"
  ) +
  scale_color_manual(values = c(
    "Poisson" = "limegreen",
    "Normal" = "mediumorchid"
  )) +
  theme_minimal(base_size = 14)
print(graph2)

ggsave("ex1_10x_cov.png")
#------------------------------Step 1.6-----------------------------------------
coverage_df3 <- read.table("coverage3.txt", header = FALSE)
colnames(coverage_df3) <- c("coverage")

xs_df3 <- read.table("coverage_values3.txt", header = FALSE)
colnames(xs_df3) <- c("xs")

poisson_df3 <- read.table("poisson_estimates3.txt", header = FALSE)
colnames(poisson_df3) <- c("poisson")

normal_df3 <- read.table("normal_estimates3.txt", header = FALSE)
colnames(normal_df3) <- c("normal")

dist_df3 <- data.frame(
  xs = xs_df3$xs,
  poisson = poisson_df3$poisson,
  normal = normal_df3$normal
)

Total <- nrow(coverage_df3)       # total number of positions
bin_width <- 1               # histogram bin width

dist_df3$poisson <- dist_df3$poisson * Total
dist_df3$normal  <- dist_df3$normal * Total * bin_width

graph3 <- ggplot() +
  
  # Histogram of coverage
  geom_histogram(
    data = coverage_df3,
    aes(x = coverage),
    binwidth = 1,
    fill = "lightsteelblue1",
    color = "black",
    boundary = 0
  ) +
  
  # Poisson distribution (line)
  geom_line(
    data = dist_df3,
    aes(x = xs, y = poisson, color = "Poisson"),
    size = 1
  ) +
  
  # Normal distribution (dashed line)
  geom_line(
    data = dist_df3,
    aes(x = xs, y = normal, color = "Normal"),
    size = 1,
    linetype = "dashed"
  ) +
  
  labs(
    title = "Genome Coverage Distribution x30",
    x = "Coverage",
    y = "Frequency",
    color = "Distributions"
  ) +
  scale_color_manual(values = c(
    "Poisson" = "limegreen",
    "Normal" = "mediumorchid"
  )) +
  theme_minimal(base_size = 14)
print(graph3)

ggsave("ex1_30x_cov.png")
