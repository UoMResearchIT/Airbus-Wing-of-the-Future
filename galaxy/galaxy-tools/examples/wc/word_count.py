import argparse
import sys

# Create the parser and add the arguments
parser = argparse.ArgumentParser(description='A script that takes a string and writes out the length of each word in the string.')
parser.add_argument('input_str', help='The string to process')
parser.add_argument('output_file', help='The name of the file to write the output to')
args = parser.parse_args()

# Get the number of words in the string (split by whitespace)
num_words = len(args.input_str.split())

# Print the number of words to the console
print(f"Number of words: {num_words}")

# Write the number of words to the output file
with open(args.output_file, 'w') as f:
    f.write(str(num_words))
