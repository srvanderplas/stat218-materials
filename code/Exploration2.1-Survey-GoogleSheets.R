library(googlesheets4)
library(tidyverse)
q10 <- read_sheet("https://docs.google.com/spreadsheets/d/1_snzmHEUdApqIqm0AtOuJPJKqHeYcWDWu2fRQb-0ki8/", sheet = 1)

windows()
q10 %>%
  set_names(c("time", "avg_word_length")) %>%
  ggplot(aes(x = avg_word_length)) +
  geom_dotplot(binwidth = 0.25, origin = 1, method = "histodot") +
  ggtitle("Question 10 Responses") +
  annotate("text", x = Inf, y = Inf, hjust = 1.1, vjust = 0, label = sprintf("Mean word length: %.2f\nProportion > 4.29: %.2f",
                                                                             mean(q10$`What is the average word length in your sample?`), mean(q10$`What is the average word length in your sample?`>4.29)))


<<<<<<< HEAD

q17 <- read_sheet("https://docs.google.com/spreadsheets/d/1_snzmHEUdApqIqm0AtOuJPJKqHeYcWDWu2fRQb-0ki8/", sheet = 2)
=======
q17 <- read_sheet("https://docs.google.com/spreadsheets/d/1_snzmHEUdApqIqm0AtOuJPJKqHeYcWDWu2fRQb-0ki8/", sheet = 2) %>% na.omit()
>>>>>>> ba4bef3439eaa6147c11991423e25b2a6f5a4576

windows()
q17 %>%
  # na.omit() %>%
  set_names(c("time", "avg_word_length")) %>%
  ggplot(aes(x = avg_word_length)) + geom_dotplot(binwidth = 0.25, origin = 1, method = "histodot") +
  ggtitle("Question 18 Responses") +
  annotate("text", x = Inf, y = Inf, hjust = 1.1, vjust = 1, label = sprintf("Mean word length: %.2f\nProportion > 4.29: %.2f",
                                                                             mean(q17$`What is the average word length in your sample?`), mean(q17$`What is the average word length in your sample?`>4.29)))
  # coord_cartesian(xlim = c(0, 10))

### Fudging things

ga <- "Four score and seven years ago our fathers brought forth on this continent, a new nation, conceived in Liberty, and dedicated to the proposition that all men are created equal. Now we are engaged in a great civil war, testing whether that nation, or any nation so conceived and so dedicated, can long endure. We are met on a great battle-field of that war. We have come to dedicate a portion of that field, as a final resting place for those who here gave their lives that that nation might live. It is altogether fitting and proper that we should do this. But, in a larger sense, we can not dedicate—we can not consecrate—we can not hallow—this ground. The brave men, living and dead, who struggled here, have consecrated it, far above our poor power to add or detract. The world will little note, nor long remember what we say here, but it can never forget what they did here. It is for us the living, rather, to be dedicated here to the unfinished work which they who fought here have thus far so nobly advanced. It is rather for us to be here dedicated to the great task remaining before us—that from these honored dead we take increased devotion to that cause for which they gave the last full measure of devotion—that we here highly resolve that these dead shall not have died in vain—that this nation, under God, shall have a new birth of freedom—and that government of the people, by the people, for the people, shall not perish from the earth."
ga_words <- str_remove(ga, "[[:punct:]]{1,}") %>% str_split(" ") %>% unlist()

ga_words_df <- tibble(word = ga_words, wt = nchar(ga_words))

res_nonrandom <- purrr::map_df(1:125, function(i) {
  tmp <- sample(ga_words_df$word, size = 10, prob = ga_words_df$wt)
  tibble(i = i, length = mean(nchar(tmp)), prop_e = mean(str_detect(tmp, "e")))
})

ggplot(res_nonrandom, aes(x = prop_e)) +
  geom_dotplot(binwidth = 0.1, origin = 1, method = "histodot", dotsize = .1) +
  ggtitle("Nonrandom sample - proportion of words containing 'e'") +
  annotate("text", x = Inf, y = Inf, hjust = 1, vjust = 1, label = sprintf("Mean # e-words in full text: %.2f\nProportion of samples with mean # e-words > %.2f: %.2f",
                                                                             mean(str_detect(ga_words, "e")), mean(str_detect(ga_words, "e")), mean(res_nonrandom$prop_e)))

mean(res_nonrandom$length>4.29)
mean(res_nonrandom$prop_e > mean(str_detect(ga_words, "e")))

res_random <- purrr::map_df(1:125, function(i) {
  tmp <- sample(ga_words_df$word, size = 10)
  tibble(i = i, length = mean(nchar(tmp)), prop_e = mean(str_detect(tmp, "e")))
})
