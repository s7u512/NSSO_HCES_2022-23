# Clear the workspace
rm(list = ls())

#Load the necessary libraries
library(readxl) # to read .xslx files
library(tidyverse) # for data manipulation


# Load the layout file
layout_data <- read_excel("./Documentation/Layout_HCES 2022-23_modified.xlsx") 
# I had to modify one cell, from "Ques. DGQ   Level - 13 (Section 14)" to "Ques. DGQ   LEVEL - 13 (Section 14)" Just the capitalization. Annoying lack of pattern.

head(layout_data)

# Rename columns based on their content (change these based on actual content if needed)
new_names <- c("Slno", "Item", "QSec", "QItem", "QCol", "Length", "Byte_Start_position", "Dash", "Byte_End_position", "Remarks")
colnames(layout_data) <- new_names

head(layout_data)

# Identify the rows for each level
levels <- which(grepl("LEVEL", layout_data$Item))

# Extract the Common-ID rows from Level 01
common_id_rows <- layout_data[4:19, c("Slno", "Item", "Length")]
common_id_rows <- common_id_rows %>% filter(!is.na(Length))  # Remove rows without Length

head(common_id_rows)

# Function to extract layout for each level
extract_level_layout <- function(start_row, next_level_start = NULL) {
  if (is.null(next_level_start)) {
    level_layout <- layout_data[start_row:nrow(layout_data), c("Slno", "Item", "Length")]
  } else {
    level_layout <- layout_data[start_row:(next_level_start - 1), c("Slno", "Item", "Length")]
  }
  level_layout <- level_layout %>% filter(!is.na(Length))
  return(level_layout)
}

# Initialize a list to store combined layouts for each level
combined_layouts <- list()

# Loop through each level and combine with Common-ID
for (i in seq_along(levels)) {
  start_row <- levels[i] + 3  # Adjust to skip the header rows
  next_level_start <- if (i < length(levels)) levels[i + 1] else nrow(layout_data) + 1
  level_layout <- extract_level_layout(start_row, next_level_start)
  
  if (i == 1) {
    # For the first level, do not add Common-ID
    combined_layout <- level_layout
  } else {
    # For other levels, add Common-ID
    combined_layout <- bind_rows(common_id_rows, level_layout)
  }
  
  combined_layouts[[i]] <- combined_layout
}

# Combine all levels into one dataframe for export if needed
final_combined_layout <- bind_rows(combined_layouts, .id = "Level")

# Caught an error
final_combined_layout <- final_combined_layout %>% filter(!(Item == "Common-ID"))

head(final_combined_layout)

write.csv(final_combined_layout, "./Output/Layout.csv", row.names = FALSE)  
