library(tidyverse)
library(lubridate)
library(Hmisc)
path <- here::here("data/Witchcraftsurvey_download.mdb")
table_list <- mdb.get(path, tables = T)
scottish_witch_trials <- mdb.get(path)

table_list

scottish_witch_trials$WDB_Trial_Person # People involved in the trial
scottish_witch_trials$WDB_Accused %>%
  left_join(select(scottish_witch_trials$WDB_Case, AccusedRef, Case.date, CaseCommonName)) %>%
  select(AccusedRef,AccusedID, Case.date, CaseCommonName, FirstName, LastName, M.Firstname, M.Surname,
         Sex, Age, Res.parish, Res.settlement, Res.presbytery, Res.county, MaritalStatus, Occupation) %>%
  mutate(case_date = dmy(Case.date), year = as.numeric(str_extract(Case.date, "\\d{4}"))) %>%
  mutate(period = case_when(year > 1627 & year <= 1630 ~ "1628-1630",
                            year > 1648 & year <= 1650 ~ "1649-1650",
                            TRUE ~ "other")) %>%
  filter(period != "other", Sex %in% c("Female", "Male")) %>%
  group_by(period, Res.county, Sex) %>% tally()
  group_by(Res.county, Sex) %>%
  summarize(count = n(), avg.age = mean(Age, na.rm = T), n.age = sum(!is.na(Age)))
scottish_witch_trials$WDB_Trial
scottish_witch_trials$WDB_Case
