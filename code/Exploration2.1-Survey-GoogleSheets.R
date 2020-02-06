library(googlesheets4)
library(tidyverse)
q10 <- read_sheet("https://docs.google.com/spreadsheets/d/1_snzmHEUdApqIqm0AtOuJPJKqHeYcWDWu2fRQb-0ki8/", sheet = 1)

q10 %>%
  set_names(c("time", "avg_word_length")) %>%
  ggplot(aes(x = avg_word_length)) +
  geom_dotplot(binwidth = 0.25, origin = 1, method = "histodot") +
  ggtitle("Question 10 Responses") +
  annotate("text", x = Inf, y = Inf, hjust = 1.1, vjust = 0, label = sprintf("Mean word length: %.2f\nProportion > 4.29: %.2f",
                                                                             mean(q10$`What is the average word length in your sample?`), mean(q10$`What is the average word length in your sample?`>4.29)))


q17 <- read_sheet("https://docs.google.com/spreadsheets/d/1_snzmHEUdApqIqm0AtOuJPJKqHeYcWDWu2fRQb-0ki8/", sheet = 2) %>% na.omit()

q17 %>%
  # na.omit() %>%
  set_names(c("time", "avg_word_length")) %>%
  ggplot(aes(x = avg_word_length)) + geom_dotplot(binwidth = 0.25, origin = 1, method = "histodot") +
  ggtitle("Question 18 Responses") +
  annotate("text", x = Inf, y = Inf, hjust = 1.1, vjust = 1, label = sprintf("Mean word length: %.2f\nProportion > 4.29: %.2f",
                                                                             mean(q17$`What is the average word length in your sample?`), mean(q17$`What is the average word length in your sample?`>4.29)))
  # coord_cartesian(xlim = c(0, 10))

