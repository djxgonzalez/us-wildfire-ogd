##============================================================================##
## makes Figure 5, results for RR estimates

## setup ---------------------------------------------------------------------

# attaches packages we need for this script
source("code/0-setup/01-setup.R")

# data input
table_rr <- read_csv("output/results/table_rr_aggregate.csv")


## generates Figure 5a -------------------------------------------------------
# pop exposed to wells in areas with KBDI ≥ 600
figure_5a <- table_rr %>%
  filter(kbdi_min == 600) %>% 
  ggplot() +
  geom_hline(yintercept = 1, linetype = "dashed", color = "#000000") +
  scale_shape_manual(values = c(3, 15, 16, 17, 18, 7, 8))+
  geom_point(aes(state, rr, color = race_ethnicity, shape = race_ethnicity), 
             size = 2) +
  scale_color_manual(name = "", 
                     values = c("#D55E00", 
                                "#56B4E9",
                                "#009E73", 
                                "#0072B2",
                                "#EF5B5B", 
                                "#88498F",
                                "#CC79A7")) +
  ylim(0, 2.3) +
  labs(x = "", y = "Risk ratio") +
  theme_classic() +
  theme(legend.position = "none")
figure_5a
# exports figure ...........................................................
ggsave(filename = "figure_5a.png", plot = figure_5a, device = "png",
       width = 6, height = 4, path = "output/figures/components")

## generates Figure 5b -------------------------------------------------------
# pop exposed to wells in areas with KBDI ≥ 600
figure_5b <- table_rr %>%
  filter(kbdi_min == 450) %>% 
  filter(rr < 5) %>%  # drops outlier in Utah with RR == 21.9 for Native Am.
  ggplot() +
  geom_hline(yintercept = 1, linetype = "dashed", color = "#000000") +
  scale_shape_manual(values = c(3, 15, 16, 17, 18, 7, 8))+
  geom_point(aes(state, rr, color = race_ethnicity, shape = race_ethnicity), 
             size = 2) +
  scale_color_manual(name = "", 
                     values = c("#D55E00", 
                                "#56B4E9",
                                "#009E73", 
                                "#0072B2",
                                "#EF5B5B", 
                                "#88498F",
                                "#CC79A7")) +
  ylim(0, 3.45) +
  labs(x = "", y = "Risk ratio") +
  theme_classic() +
  theme(legend.position = "none")
figure_5b
# exports figure ...........................................................
ggsave(filename = "figure_5b.png", plot = figure_5b, device = "png",
       width = 6, height = 6, path = "output/figures/components")

##============================================================================##