library(googlesheets4)
library(tidyverse)
q10 <- read_sheet("https://docs.google.com/spreadsheets/d/1_snzmHEUdApqIqm0AtOuJPJKqHeYcWDWu2fRQb-0ki8/", sheet = 1)

windows()
q10 %>%
  set_names(c("time", "avg_word_length")) %>%
  ggplot(aes(x = avg_word_length)) + geom_dotplot(binwidth = 0.25, origin = 1, method = "histodot") +
  ggtitle("Question 10 Responses")



q17 <- read_sheet("https://docs.google.com/spreadsheets/d/1_snzmHEUdApqIqm0AtOuJPJKqHeYcWDWu2fRQb-0ki8/", sheet = 2)

windows()
q17 %>%
  set_names(c("time", "avg_word_length")) %>%
  ggplot(aes(x = avg_word_length)) + geom_dotplot(binwidth = 0.25, origin = 1, method = "histodot") +
  ggtitle("Question 18 Responses")
