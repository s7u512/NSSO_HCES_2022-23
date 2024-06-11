# Clear the workspace
rm(list = ls())

# Load necessary libraries
library(tidyverse) # for data manipulation
library(readr) # to read fixed width files
library(readxl) # to read spreadsheets in .xlsx format
library(future) # for parallel processing
library(furrr) # for parallel processing
library(data.table) # for saving large csv files efficiently

#######

# Read the layout file which contains the structure of the fixed-width files
layout <- read.csv("./Output/Layout.csv")

# Display the layout for reference
head(layout)

# Get the unique levels from the layout
levels <- unique(layout$Level)

# Read the State List from the documentation
# This file contains state codes and their corresponding names
State_list <- read_excel("Documentation/tabulation_state_code.xlsx") %>% select(c("st", "stn"))
# Convert state codes to numeric for consistency
State_list$st <- as.numeric(State_list$st)
# Display the first few rows of the State List for reference
head(State_list)

########

# Set up parallel processing with specified number of workers
# It uses all but two cores/threads of your system
plan(multisession, workers = parallel::detectCores() - 2) 


# Define a function to read a fixed-width file based on the level
read_fwf_level <- function(level) {
  # Get the file name based on the level
  file_name <- sprintf("./RawData/hces22_lvl_%02d.TXT", level)
  
  # Get the subset of layout for the current level
  current_layout <- layout %>% filter(Level == level)
  
  # Get column widths and names
  column_widths <- current_layout$Length
  column_names <- make.names(current_layout$Item)
  
  # Read the fixed-width file using fwf_widths and make.names
  df <- read_fwf(
    file = file_name, 
    col_positions = fwf_widths(
      widths = column_widths, 
      col_names = column_names
    ),
    col_types = cols(
      Survey.Name = col_character(), 
      Questionnaire.No. = col_character(), 
      .default = col_number()
    )
  )
  
  # Add computed columns: Weights, HH_ID, and StateName
  df <- df %>%
    mutate(Weights = Multiplier / 100,
           HH_ID = paste0(FSU.Serial.No., Second.stage.stratum.no., Sample.hhld..No.),
           StateName = factor(State, 
                              levels = State_list$st, 
                              labels = State_list$stn))
  
  return(df)
}

# Use future_map to read files in parallel and return a list of data frames
data_frames <- future_map(levels, read_fwf_level)

# End the multisession by resetting the plan to sequential
plan(sequential)

# Assign the data frames to the global environment with dynamic names
for (i in seq_along(levels)) {
  assign(paste0("level_", levels[i]), data_frames[[i]], envir = .GlobalEnv)
}


#######

# Loop to save data frames

# Code block to iterate through all relevant data frames, and save them both as RData and csv files

# Get a list of objects in the global environment at the moment (NOTE: This takes all objects in the global enviroment, which means it will create confusions if you were running other codes and had other objects from other scripts in the global environment)
obj_list <- ls()

# Define a function that runs some checks to see if we want to save a given object in the global enviroment or not.
tobesaved <- sapply(                              
  obj_list, function(x)                          
  {
    is.data.frame(get(x)) &&                      
      startsWith(x, "level_")                   
  }
)

# Additional Explanation for code above:
# sapply() applies whatever function we specify to all the elements in a list we specify. In this case function(x) is applied to obj_list
# function (x) as defined in the code, returns TRUE if all three conditions specified inside the {} are met. It returns FALSE otherwise.
# It checks if the item in the list is a data frame, and
# It checks if the item start with "level_"
# So for each item in the list called obj_list, function (x) returns a TRUE or FALSE value


# Run a loop that takes each item in obj_list, sees if it has to be saved, and then saves it if true.
for (i in obj_list[tobesaved]) {
  save(list = i, file = file.path(paste0("./Output/",i,".Rdata")))
  fwrite(get(i), file = file.path(paste0("./Output/",i,".csv")))
}

# Clear the workspace
rm(list = ls())

# The End
