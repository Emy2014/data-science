performance <- read.csv("data/raw/ResearchInformation3.csv")
dim(performance)

install.packages("dplyr")
install.packages("tidyverse")
library(dplyr)
library(tidyverse)

clean_performance <- performance %>% 
  filter(Department == "Computer Science and Engineering")

clean_performance$Attendance <- factor(clean_performance$Attendance, 
                          levels = c("Below 40%","40%-59%","60%-79%","80%-100%"),
                          labels = c("Extremely Low Attendance", "Low", "Medium", "High"))

clean_performance$Preparation <-factor(clean_performance$Preparation,
                          levels = c("0-1 Hour", "2-3 Hours","More than 3 Hours"),
                          labels = c("0-1 Hour", "2-3 Hours", "More than 3 Hours"))

clean_performance$Gender <-factor(clean_performance$Gender,
                     levels = c("Male", "Female"),
                     labels = c("Male", "Female"))

write_csv(clean_performance, file = "data/model/clean_student_performance.csv")
