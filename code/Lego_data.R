library(LegoR)
library(tidyverse)
# sets_by_decade <- tibble(min_year = seq(1950, 2010, by = 10), max_year = seq(1959, 2020, by = 10)) %>%
#   mutate(sets = map2(min_year, max_year, ~{rebrickable_sets(min_year = .x, max_year = .y, page_length = 100, follow_next = T); Sys.sleep(3)}))
#
# sets_by_decade <- sets_by_decade %>%
#   select(decade = min_year, sets = sets) %>%
#   unnest("sets")
#
# write_csv(sets_by_decade, here::here("data/lego-by-decade.csv"))
#
# themes <- rebrickable_themes()
# write_csv(themes, here::here("data/lego-themes.csv"))
#
# sets_by_decade %>%
#   filter(num_parts > 5) %>%
#   ggplot(aes(x = factor(decade), y = num_parts)) + geom_boxplot() + scale_y_log10()
#
#
# left_join(filter(themes, str_detect(name, "Pirates")) %>% rename(theme_id = id, theme_name = name, theme_parent = parent_id),
#           sets_by_decade)
#
# left_join(filter(themes, str_detect(name, "Castle")) %>% rename(theme_id = id, theme_name = name, theme_parent = parent_id),
#           sets_by_decade)
#
# left_join(filter(themes, str_detect(name, "Classic Space")) %>% rename(theme_id = id, theme_name = name, theme_parent = parent_id),
#           sets_by_decade)
#
# left_join(filter(themes, str_detect(name, "Trains")) %>% rename(theme_id = id, theme_name = name, theme_parent = parent_id),
#           sets_by_decade)
# filter(sets_by_decade, )

themes <- c("Creator", "Friends", "Ninjago", "Space")
sets <- purrr::map_df(themes, ~brickset_get_sets(theme = ., pageSize = "1000"))

useful_sets <- sets %>%
  filter(usretailprice > 10.00 & usretailprice < 70.00)

write_csv(useful_sets, path = here::here("data/lego_sets_theme.csv"))
#
# %>%
#   group_by(theme) %>% tally()

themelist <- brickset_get_themes()
themelist %>% arrange(desc(setcount))

