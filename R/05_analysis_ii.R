# Danli
library("tidyverse")
library("RColorBrewer")

#Open data set
data = read_csv("./data/03_otu_counts_long_aug.csv")

#plot1
df <- data %>% 
  select(c(Month,
           Count,
           Group)) %>%
  mutate(Month =ordered(Month, 
                        levels = unique(Month)))

p1 <- ggplot(data = df, aes(x = Month, 
                          y = Count, 
                          fill = Group)) + 
    geom_bar(stat = "identity")  + 
    xlab("") + 
    ggtitle("Seasonal variation in proportional read abundance") +
    xlab("Months") +
    ylab("Porpotion of reads") +
    theme(axis.text=element_text(size=8,
                                 angle=90))
p1 + scale_fill_brewer(palette = "PiYG")

ggsave("results/Seasonal variation in proportional read abundance.png",
       plot = p1,
       width = 25,
       height = 12,
       units = "cm")

#plot 2
df2 <- df %>% 
  select(Month,
         Count,
         Group) %>%
  mutate(Count = replace(Count, 
                         Count > 0, 
                         1))

p2 <- ggplot(data = df2, aes(x = Month, 
                           y = Count)) + 
  geom_col(aes(fill = Group)) + 
  ggtitle("OTU richness of the major haptophyte groups") +
  xlab("Months") +
  ylab("Number of OTUs") +
  theme(axis.text=element_text(size=8, 
                               angle=90))
p2 + scale_fill_brewer(palette = "PiYG")

ggsave("results/OTU richness of the major haptophyte groups.png",
       plot = p2,
       width = 25,
       height = 12,
       units = "cm")

