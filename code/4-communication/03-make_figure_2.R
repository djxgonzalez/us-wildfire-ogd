##============================================================================##
## makes Figure 2 - ...

## setup ---------------------------------------------------------------------

# attaches necessary packages
library("ggspatial")

# data input


## manuscript figure ---------------------------------------------------------

# figure 2a ................................................................
figure_2a <- ggplot() 
# exports figures
ggsave(filename = "figure_2a.png", plot = figure_2a, device = "png",
       height = 6, width = 6, path = "output/figures/components/")

# figure 2b ................................................................
figure_2b <- ggplot() 
# exports figures
ggsave(filename = "figure_2b.png", plot = figure_2b, device = "png",
       height = 6, width = 6, path = "output/figures/components/")

##============================================================================##