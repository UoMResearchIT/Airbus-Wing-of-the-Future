import argparse
import sys

# Create the parser and add the arguments
parser = argparse.ArgumentParser(description='A script that takes a string and writes out the length of each word in the string.')
parser.add_argument('input_str', help='The string to process')
parser.add_argument('output_file', help='The name of the file to write the output to')
args = parser.parse_args()

# List comprehension to get the length of each word in the string
word_lengths = [str(len(word)) for word in args.input_str.split()]

# Print the word lengths to the console
print(f"Word lengths: {', '.join(word_lengths)}")

# Write the word lengths to the output file
with open(args.output_file, 'w') as f:
    f.write(','.join(word_lengths))
