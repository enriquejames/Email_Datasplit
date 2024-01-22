library(dplyr)
library(readxl)

#SET WORKING DIR AND ENTER CSV NAME BELOW!
df <- read.csv("Email Assembled Import v0.1 - Emails Created.csv")


duplicate_rows <- function(df, email_count_column) {
  df[rep(seq_len(nrow(df)), df[[email_count_column]]), ]
}

df_adjust <- duplicate_rows(df, "X..Emails.Created")

df_final<- df_adjust %>%  mutate(CreatedAt= Date, 
                                 ImportID = NA, 
                                 Channel = NA,
                                 Status = NA,
                                 AssigneeImportID = NA,
                                 FirstRespondedAt = NA,
                                 HandleTime = NA,
                                 SolvedAt = NA,
                                 Tags = NA,
                                 Queue = Email.Queue) %>%
  select(CreatedAt, ImportID, Channel, Status, AssigneeImportID, FirstRespondedAt, HandleTime, SolvedAt, Tags, Queue)

df_final$Channel <- "email"
df_final$Status <- "solved"

current_date <- format(Sys.Date(), "%Y%m%d")
starting_id <- as.numeric(paste0(current_date, "000001"))
ids <- starting_id:(starting_id + nrow(df_final) - 1)
df_final$ImportID <- ids

filename <- paste0(current_date, " Voice Data.csv")
write.csv(df_final, filename, row.names = FALSE)
