import argparse
import sys
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

# Create the parser and add the arguments
parser = argparse.ArgumentParser(description='A script that takes a single column file of numbers and generates a csv representing a histogram of the data. Optionally normalises the data using a normalisation factor supplied in a separate file.')
parser.add_argument('input_file', help='The file to process')
parser.add_argument('output_image', help='The name of the file to write the output image to')
parser.add_argument('normalisation_factor', help='The normalisation factor to apply to the data', nargs='?', default=None)
args = parser.parse_args()

# Read the input file
data = np.loadtxt(args.input_file)

# Read the normalisation factor, if provided, and set the title accordingly
normalisation_factor = 1
title = 'Histogram of Letter Counts'
if args.normalisation_factor:
    with open(args.normalisation_factor, 'r') as f:
        normalisation_factor = int(f.read())
    title = f'Histogram of Letter Counts (Normalised)'

# Create an array of weights
weights = np.ones_like(data) / float(normalisation_factor)

# Plot the histogram
plt.hist(data, bins=10, weights=weights)
plt.xlabel('Count')
plt.ylabel('Frequency')
plt.title(title)
plt.savefig(args.output_image)
