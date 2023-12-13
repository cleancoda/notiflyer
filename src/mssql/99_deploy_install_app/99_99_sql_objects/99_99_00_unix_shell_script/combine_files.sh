#!/bin/bash

# **NOTE** - this is NOT the recommended way of installing notiflyer
# only intended to test and verify scripts;

# instructions - move this script into the folder that needs to be
# combined into a single file - example: copy script into 00_setup_ddl_create_objects
# and run from terminal - it will generate a new 'create' script for notiflyer

# Variables
DIRECTORY="."
OUTPUT_FILE="combined.sql"

# Initialize the output file
> $OUTPUT_FILE

# Loop through each file in the directory and its subdirectories
find $DIRECTORY -type f -name '*.sql' | while read FILE
do

  # Add a comment to the beginning of the file
  echo "-- Start of $FILE" >> $OUTPUT_FILE

  # Append the contents of the file to the output file
  cat "$FILE" >> $OUTPUT_FILE

  # Add a newline to the end of the file
  echo "" >> $OUTPUT_FILE

  # Add a comment to the end of the file
  echo "-- End of $FILE" >> $OUTPUT_FILE
done

echo "All files have been combined into $OUTPUT_FILE."