usethis::use_git()
usethis::use_github()

library(tidyverse, quietly = TRUE)
library(cranlogs)
theme_set(theme_minimal() +
            theme(legend.position = "bottom"))

my_pkgs <- tools::CRAN_package_db() |>
  filter(str_detect(Author, "Jonah Gabry"))
my_pkgs |>
  as_tibble() |>
  select(Package, Version, Author)

brms_rstanarm <- my_pkgs[c(3,11), c(1,2,17)]

brms_rstanarm

download_data <- brms_rstanarm |>
  pull(Package) |>
  cran_downloads(from = "2015-01-01", to = Sys.Date()) |>
  filter(count > 0) |>
  group_by(package) |>
  mutate(count_total = cumsum(count))

ggplot(download_data, aes(x = date, y = count_total, colour = package)) +
  geom_line() +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_manual(values = wesanderson::wes_palette("Royal1")) +
  labs(x = NULL, y = NULL, colour = NULL, titletitle = "Package Downloads over time",
       caption = paste0("Data source: cranlogs.r-pkg.org; Updated: ", Sys.Date()))
