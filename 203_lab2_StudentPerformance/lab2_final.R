install.packages("fec16")
library(fec16)
library(tidyverse)
library(patchwork)
library(stargazer)
library(sandwich)
library(lmtest)
library(broom)

data <- read.csv('data/model/clean_student_performance.csv')
dim(data)
# conducted factorization in src (data_cleaning.R) file

# regression
## linear regression models ##
simple <- lm(data = data, Overall ~ HSC)
summary(simple)

complex <- lm(data = data, Overall ~ HSC + Gender + Attendance)
summary(complex)


## stargazer tables ##
simplerobust <- sqrt(diag(vcovHC(simple)))
complex_robust <- sqrt(diag(vcovHC(complex)))

# combine 2 stargazer tables in one
stargazer(simple, complex, type = "text",
          column.labels = c("simple model", "complex model"),
          se = list(simplerobust, complex_robust),
          dep.var.labels = "Overall GPA")
# analysis 
## anova ##
anova(simple, complex, test="F")

## coeftest ##
coeftest(simple, vcov. = vcovHC(simple))
coeftest(complex, vcov. = vcovHC(complex))

# plots
### scatterplot ###
gpa_plot <- ggplot(data, aes(x = HSC, y = Overall, color = Attendance))+ 
  geom_point(size = 2)+
  facet_wrap(~ Gender)+
  labs(title = "Scatterplot of College GPA vs High School GPA", x = "High School GPA", 
       y = "College GPA", color = "Attendance")+
  scale_color_manual(values = c(
    "Extremely Low Attendance" = "#96221b", "Low" = "#fb6b27", "Medium" = "#fecb3f", "High" = "#1a9850"),  
    breaks = c("High", "Medium", "Low", "Extremely Low Attendance")) +
  theme_minimal()+
  theme(legend.position = "top", legend.key.height = unit(0.5, "cm"),
        legend.key.width = unit(0.4, "cm"), legend.text = element_text(size = 7.5),
        legend.title = element_text(size = 8.5))+
  theme(axis.text.x = element_text(angle = 30, hjust = 1)) 
gpa_plot

### assumption plots ###
