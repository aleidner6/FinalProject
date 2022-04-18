# FinalProject

We are trying again.


stop here

Working down here
Yay!!



{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)


## R Markdown

```{r libraries}
library(tidyverse)     # for data cleaning and plotting
library(gardenR)       # for Lisa's garden data
library(lubridate)     # for date manipulation
library(openintro)     # for the abbr2state() function
library(patchwork)     # for nicely combining ggplot2 graphs  
library(gt)            # for creating nice tables
library(rvest)         # for scraping data
library(robotstxt)     # for checking if you can scrape data
library(janitor)       # for cleaning names
library(baseballr)
library(sportyR)
library(pitchRx)
library(Lahman)
install.packages("pacman")


head(Master)

```


if (!requireNamespace('pacman', quietly = TRUE)){
  install.packages('pacman')
}
pacman::p_load_current_gh("BillPetti/baseballr")
```

```{r my_libraries, include=FALSE}
# Lisa needs this, students don't
library(downloadthis) # for including download buttons for files
library(flair)        # for highlighting code
#library(xaringanExtra)# for small slides and other cool things
```


```{r}
#geom_baseball(league = "MLB")
#geom_basketball(league = "NBA")

# dat <- scrape("2015-05-21", "2015-05-21")
# locations <- select(dat$pitch, pitch_type, start_speed, px, pz, des, num, gameday_link)
# names <- select(dat$atbat, pitcher, batter, pitcher_name, batter_name, num, gameday_link, event, stand)
# data <- names %>% filter(pitcher_name == "Jacob DeGrom") %>% inner_join(locations, ., by = c("num", "gameday_link"))
```

# ```{r}
# alonso <- read_html("https://baseballsavant.mlb.com/savant-player/pete-alonso-624413?stats=statcast-r-hitting-mlb")
# ```

```{r}
alonsodata <- read_csv("/Users/annaleidner/Desktop/Data Science/FinalProject/alonsodata1.csv") 


alonsodata %>%
  #filter(Result == "home_run") %>%
  ggplot(aes(x = `LA (°)`, 
             y = `EV (MPH)`, 
             color = `Result`)) +
  geom_point() +
  labs(title = "Home Run launch angle vs exit velocity", 
       x = "Launch Angle", 
       y = "Exit Velocity")
```