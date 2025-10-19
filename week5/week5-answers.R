library(tidyverse)
library(palmerpenguins)
library(broom)
setwd("/Users/cmdb/qb25-answers/week5")

# Step 1.1
probands <- read_csv("aau1043_dnm.csv")

# Step 1.2
per_proband <- probands %>%
  group_by(Proband_id) %>%
  summarise(
    mother_count= sum(Phase_combined == "mother", na.rm = TRUE),
    father_count= sum(Phase_combined == "father", na.rm = TRUE))
print(per_proband) 

# Step 1.3
parental_ages <- read_csv("aau1043_parental_age.csv")

# Step 1.4
joined <- inner_join(per_proband, parental_ages, by = "Proband_id")

# Step 2.1
ggplot(data= joined, 
       aes(x = mother_count, y = Mother_age))+
  geom_point()
ggsave("ex2_a.png")

ggplot(data= joined, 
       aes(x = father_count, y = Father_age))+
  geom_point()
ggsave("ex2_b.png")

# Step 2.2
m1 <- lm(data = joined, formula = mother_count ~ 1 + Mother_age)
summary(m1)

# Step 2.3
m2 <- lm(data = joined, formula = father_count ~ 1 + Father_age)
summary(m2)

# Step 2.4
new_obs <- tibble(Father_age = 50.5)

predict(m2, newdata = new_obs)

# Step 2.5
joined_long <- joined %>% 
  pivot_longer(
  cols = c(mother_count, father_count),
  names_to = "Parent",
  values_to = "DNM_Count"
)

ggplot(data = joined_long,
       aes(x = DNM_Count,
           fill = Parent
           )) +
  geom_histogram(bins = 20, position = 'identity', alpha = 0.5)+
  labs(title = "DNMs Distributions by Parent",
       y = "Frequency",
       x = "DNM Count")
ggsave("ex3_b.png")

# Step 2.6
t.test(joined$mother_count, joined$father_count, paired = TRUE)





# Step 3.2 (I apologize for how bad this part is I plan on resubmitting)

grosses <- read.csv("grosses.csv")

## Gross for each musical on week one separated by theater
ambassador_theatre <- grosses %>%
  filter(week_number == 1, theatre == "Ambassador Theatre") %>%
  select(week_number, show, weekly_gross)


ggplot(data = ambassador_theatre,
       aes(x = weekly_gross,
           fill = show
       )) +
  geom_histogram(bins = 20, position = 'identity', alpha = 0.5)+
 # scale_x_log10() +
  labs(title = "Gross by Show on Opening Week ",
       y = "Gross",
       x = "")
# Bar Graph
bar_data <- grosses %>%
  filter(theatre == "Ambassador Theatre") %>%
  select(show, week number)


ggplot(data = bar_data,
       aes(y = weekly_gross_overall
       )) +
  geom_bar() 
#  labs(title = "stuff",
#       y = "Total Gross",
#       x = "Show")
# ggsave("ex3_gross_by_musical.png")

#shows that did the best on week 1 do best overall



