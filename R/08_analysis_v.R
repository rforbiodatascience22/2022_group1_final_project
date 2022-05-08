# Mathias
library("tidyverse")

model_data <- read.csv("data/03_temp_model_dat_aug.csv")

models <- model_data %>% 
  group_by(parameter) %>% 
  nest() %>% 
  ungroup() %>% 
  mutate(mdl = map(data, ~lm(value ~ temperature, data = .x))) %>% 
  mutate(mdl_details = map(mdl, broom::tidy, conf.int = TRUE)) %>% 
  unnest(mdl_details)

# To see which parameters have a significant dependency on temperature
parameters_vs_temperature <- models  %>% 
  filter(term != "(Intercept)") %>% 
  select(parameter, coefficient = estimate, p.value) %>% 
  arrange(p.value)

write.csv(parameters_vs_temperature,
          file = "results/parameters_vs_temperature.csv",
          row.names = FALSE)

phos_vs_temp.data <- model_data %>% 
  filter(parameter == "Phos") %>% 
  select(temperature,
         Phos = value) %>% 
  drop_na()

# Defining slopes and intercepts
phos_vs_temp.model <- models %>% 
  filter(parameter == "Phos") %>% 
  select(term, estimate, conf.low, conf.high) 

slope <- phos_vs_temp.model %>% 
  filter(term == "temperature") %>% 
  pull(estimate)
slope.upper <- phos_vs_temp.model %>% 
  filter(term == "temperature") %>% 
  pull(conf.high)
slope.lower <- phos_vs_temp.model %>% 
  filter(term == "temperature") %>% 
  pull(conf.low)

intercept <- phos_vs_temp.model %>% 
  filter(term == "(Intercept)") %>% 
  pull(estimate)
intercept.upper <- phos_vs_temp.model %>% 
  filter(term == "(Intercept)") %>% 
  pull(conf.high)
intercept.lower <- phos_vs_temp.model %>% 
  filter(term == "(Intercept)") %>% 
  pull(conf.low)

datapoints <- geom_point(mapping = aes(y = Phos),
                         color = "red",
                         shape = 18,
                         size = 3)
regression_line <- geom_line(mapping = aes(y = intercept + slope * temperature))
lower_bound <- geom_line(mapping = aes(y = intercept.lower + slope.lower * temperature),
                         linetype = "dashed")
upper_bound <- geom_line(mapping = aes(y = intercept.upper + slope.upper * temperature),
                         linetype = "dashed")

p <- ggplot(data = phos_vs_temp.data,
       mapping = aes(x = temperature)) +
  datapoints +
  regression_line +
  lower_bound +
  upper_bound +
  labs(x = "Temperature (°C)",
       y = "Phosphate (μM)",
       title = "Phosphate concentration as a function of temperature",
       subtitle = "Averaged over the mixed layer") +
  theme_classic()

ggsave("results/phosphate_vs_temperature.png",
       plot = p,
       width = 20,
       height = 14,
       units = "cm")

rm(list = ls())
