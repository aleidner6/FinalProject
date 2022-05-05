
#anna's app
library(shiny)
library(tidyverse)
library(sportyR) 
library(stringr)
library(rsconnect)
library(fmsb)
library(shinydashboard)
library(ggthemes)

cleanlocationdata <- read_csv("https://raw.githubusercontent.com/aleidner6/FinalProject/main/cleanlocationdata.csv")
Full_2021_hitting_stats <- read_csv("https://raw.githubusercontent.com/Ballardk/FinalProject/main/Full_2021_hitting_stats.csv")
pitching_data <- read_csv("https://raw.githubusercontent.com/aleidner6/FinalProject/main/Pitching%20Data.csv")
spray_chart <- read_csv("https://raw.githubusercontent.com/aleidner6/FinalProject/main/cleanlocationdata.csv")
pitching_data <- pitching_data %>%
  unite("Name", first_name:last_name,
        sep = " ")  
Thrown_pitches <- 
  select(pitching_data, c(Name, n_fastball_formatted, n_breaking_formatted, n_offspeed_formatted)) %>% 
  rename( "FastBall" = n_fastball_formatted, 'Breaking Ball' = n_breaking_formatted, "Offspeed Pitch" = n_offspeed_formatted)

Spider_pitch <- select(pitching_data, c(Name, p_total_hits, p_home_run, p_k_percent, barrel_batted_rate, z_swing_miss_percent, n_fastball_formatted, n_breaking_formatted, n_offspeed_formatted)) %>% 
  add_row(Name = "Mean", p_total_hits = 159.7436	 , p_home_run = 22 ,p_k_percent = 24.75128	,  barrel_batted_rate = 7.066667, z_swing_miss_percent = 18.57436, n_fastball_formatted = 56.31026	, n_breaking_formatted = 28.05897	, n_offspeed_formatted = 15.62821, .before = 2) %>% 
  
  add_row(Name = "Max", p_total_hits = 200	 , p_home_run = 40 ,p_k_percent = 36	,  barrel_batted_rate = 10, z_swing_miss_percent = 26, n_fastball_formatted = 75	, n_breaking_formatted = 55	, n_offspeed_formatted = 45, .before = 3) %>% 
  
  add_row(Name = "Min", p_total_hits = 115	 , p_home_run = 5 ,p_k_percent = 12	,  barrel_batted_rate = 3, z_swing_miss_percent = 10, n_fastball_formatted = 35	, n_breaking_formatted = 0	, n_offspeed_formatted = 0, .before = 4) %>% 
  
  rename( "Col1" = Name, "Hits Against" = p_total_hits, "HR Against" =  p_home_run, "Strike out pct" = p_k_percent, "Barrel Batted Rate" = barrel_batted_rate, "Strike Zone miss rate" =  z_swing_miss_percent, "Fastball rate" =  n_fastball_formatted, "Breakingball rate" =  n_breaking_formatted,  "Offspeed Rate" = n_offspeed_formatted, .before = 1)

Final_pitch <- Spider_pitch %>% 
  column_to_rownames(var = ".before")

Long_table <- pivot_longer(Thrown_pitches, cols=2:4, names_to = "Pitch", values_to = "Percent")

Radar_Chart_data <- Full_2021_hitting_stats %>%
  unite("Name", first_name:last_name,
        sep = " ") %>% 
  arrange(desc(batting_avg)) 

Spider_data <- select(Radar_Chart_data, c(Name, batting_avg , b_total_hits , b_home_run, exit_velocity_avg , barrel_batted_rate, sweet_spot_percent)) %>% 
  add_row(Name = "Mean", batting_avg = 0.2646894 , b_total_hits = 140.447 , b_home_run = 23.2197, exit_velocity_avg = 89.68485	 , barrel_batted_rate = 9.501515, sweet_spot_percent = 34.35076, .before = 1) %>% 
  
  add_row(Name = "Max", batting_avg = 0.5 , b_total_hits = 200 , b_home_run = 50, exit_velocity_avg = 100 , barrel_batted_rate = 25, sweet_spot_percent = 40, .before = 1) %>% 
  add_row(Name = "Min", batting_avg = 0 , b_total_hits = 95 , b_home_run = 0, exit_velocity_avg = 75 , barrel_batted_rate = 0, sweet_spot_percent = 15, .before = 2) %>% 
  
  rename("Batting Avg" = batting_avg,
         "Total Hits" = b_total_hits,
         "Home Runs" = b_home_run ,
         "Exit Velocity Avg" = exit_velocity_avg,
         "Barrel Rate" = barrel_batted_rate,
         "Sweet Spot %" = sweet_spot_percent)

Final_data <- Spider_data %>% 
  column_to_rownames(var = "Name")

Names_4_dropbox <- Full_2021_hitting_stats %>%
  unite("Name", first_name:last_name,
        sep = " ")
Names_keep <- select(Names_4_dropbox, c(Name)) %>% 
  rename("player_name" = Name)
Shared_Names <- cleanlocationdata %>%
  inner_join(Names_keep, by = c("player_name" = "player_name"))

ui <- dashboardPage(
  dashboardHeader(title = "Anna and Ballard's Baseball Player Data", titleWidth = 450),
  dashboardSidebar(selectInput(inputId = "Batter", 
                               label = "Select a Batter to View Stats:", 
                               choices = Shared_Names %>%
                                 arrange(player_name) %>%
                                 distinct(player_name) %>%
                                 pull(player_name),
                               multiple = FALSE),
                   selectInput(inputId = "Pitcher", 
                               label = "Select a Pitcher to View Stats:", 
                               choices = Long_table %>%
                                 arrange(Name) %>%
                                 distinct(Name) %>%
                                 pull(Name),
                               multiple = FALSE),
                   submitButton(text = "Welcome to the Show!")),
  
  
  dashboardBody(fluidRow(
    box(title = "Batters Radar and Spray Charts",width = 12, hight = 25, background = "maroon"),
    box(plotOutput("radarchart", height = 400)),
    box(plotOutput("spraychart", height = 400)),
    box(title = "Pitcher Radar and Pitch Percentage Chart", width = 12, hight = 25, background = "yellow"),
    box(plotOutput("Pitcher_Chart", height = 400)),
    box(plotOutput("Pitcher_Bar", height = 400)),
    box(
      title = "Key terms and Definitions",width = 12, hight = 40, background = "blue",
      "Barrel = The perfect combination of exit velocity and launch rate; Breaking Balls = A pitch that does not travel straight; Offspeed Pitch = A pitch thrown slower than a fastball; Fastball = A fast direct pitch;
     Strike zone = the Area above the plate between the batter's chest and knees; Sweet spot = a batted-ball with a launch angle between eight and 32 degrees; Batting avgerage = A players hits/total at bats. ",),
    box(title = "Data and Sources", width = 12, hight = 25, background = "black", "The majority of our data was collected from baseballsavant.mlb.com, with some data coming from the Lahman and sportR libraries.")
  )))
scaled <- Shared_Names %>%
  #filter(Batter %in% input$player_name) %>%
  mutate(x = 2.5 * (hc_x - 125.42)) %>%
  mutate(y = 2.5 * (198.27 - hc_y))
# 
# server <- function(input, output) {
#   react <- reactive({input$Charts
#   })
server <- function(input, output){
  output$spraychart <- renderPlot({
    geom_baseball(league = "MLB") +
      geom_point(data = scaled %>% 
                   filter(player_name == input$Batter),
                 aes(x = x,
                     y = y,
                     color = events), 
                 size = 2) +
      scale_color_manual(values = c('lightblue', 'darkorchid1', 'black', 'orange', 'yellow')) +
      labs(col = "Hit Type")
  })
  output$radarchart <- renderPlot({
    Shiny_filter = Final_data[c("Max", "Min", input$Batter , "Mean"), ]
    
    
    
    colors_border = c(rgb(0.2, 0.5, 0.5, 0.9),
                      rgb(0.8, 0.2, 0.5, 0.9) ,
                      rgb(0.7, 0.5, 0.1, 0.9))
    colors_in = c(rgb(0.2, 0.5, 0.5, 0.4),
                  rgb(0.8, 0.2, 0.5, 0.4) ,
                  rgb(0.7, 0.5, 0.1, 0.4))
    
    radarchart(Shiny_filter,
               pcol = colors_border ,
               pfcol = colors_in ,
               plwd = 2 ,
               plty = 1,
               cglcol = "grey",
               cglty = 1,
               axislabcol = "grey",
               cglwd = 0.8,
               vlcex = 0.8,
               title = input$Batter,
               sub = "The green shape represents the player data, while the red shape is the mean of of all hitters in the data set.")
    
  })
  output$Pitcher_Chart <- renderPlot({
    Shiny_filter = Final_pitch[c("Max", "Min", input$Pitcher, "Mean" ), ]
    
    
    
    colors_border = c(rgb(0.2, 0.5, 0.5, 0.9),
                      rgb(0.8, 0.2, 0.5, 0.9) ,
                      rgb(0.7, 0.5, 0.1, 0.9))
    colors_in = c(rgb(0.2, 0.5, 0.5, 0.4),
                  rgb(0.8, 0.2, 0.5, 0.4) ,
                  rgb(0.7, 0.5, 0.1, 0.4))
    radarchart(Shiny_filter,
               pcol = colors_border ,
               pfcol = colors_in ,
               plwd = 2 ,
               plty = 1,
               cglcol = "grey",
               cglty = 1,
               axislabcol = "grey",
               cglwd = 0.8,
               vlcex = 0.8,
               title = input$Pitcher,
               sub = "The green shape represents the Player Data, while ther red shape is the mean of of all Pitchers in the data set.")
  })
  output$Pitcher_Bar <- renderPlot({
    Long_table %>% 
      filter(Name == input$Pitcher) %>% 
      group_by(Name, Pitch) %>% 
      ggplot(aes(x = Name, y = Percent, fill = Pitch))+
      geom_col()+
      labs(y = "Percent of Pitches thrown",
           x = "Name",
           col= "Pitch Type")+
      theme_tufte()+
      theme(plot.background = element_rect(fill = "cornsilk"))
    
  })
}





shinyApp(ui = ui, server = server)
