import argparse
import sys
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

# Create the parser and add the arguments
parser = argparse.ArgumentParser(description='A script that takes a single column file of numbers and generates a csv representing a histogram of the data.')
parser.add_argument('input_file', help='The file to process')
parser.add_argument('output_image', help='The name of the file to write the output image to')
args = parser.parse_args()

# Read the input file
data = np.loadtxt(args.input_file)

# Plot the histogram
plt.hist(data, bins=10)
plt.xlabel('Count')
plt.ylabel('Frequency')
plt.title('Histogram of Letter Counts')
plt.savefig(args.output_image)
