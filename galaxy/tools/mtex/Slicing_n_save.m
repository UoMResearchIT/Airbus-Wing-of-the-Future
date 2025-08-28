%% Import Script for EBSD Data
%
% This script was automatically created by the import wizard. You should
% run the whoole script or parts of it in order to import your data. There
% is no problem in making any changes to this script.

%% Specify Crystal and Specimen Symmetries

% crystal symmetry
CS = {... 
  'notIndexed',...
  crystalSymmetry('6/mmm', [3 3 4.7], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Ti-Hex', 'color', [0.53 0.81 0.98]),...
  crystalSymmetry('m-3m', [3.2 3.2 3.2], 'mineral', 'Titanium cubic', 'color', [0.56 0.74 0.56])};

% plotting convention
setMTEXpref('xAxisDirection','north');
setMTEXpref('zAxisDirection','outOfPlane');

%% Specify File Names

% Define the sample name here (change this value for another sample)
% sampleName = '1206634_L-TL';
sampleName = '1059359_TL-L';

% path to files
% pname = 'C:\Users\s79606xz\The University of Manchester Dropbox\Xiaohan Zeng\1-Nextwing\3-EBSD\1-data\1206634';
pname = 'C:\Users\s79606xz\The University of Manchester Dropbox\Xiaohan Zeng\1-Nextwing\3-EBSD\1-data\1059359_TL-L';

% which files to be imported
fname = fullfile(pname, [sampleName, '.cpr']);

%% Import the Data

% create an EBSD variable containing the data
ebsd = EBSD.load(fname,CS,'interface','crc',...
  'convertEuler2SpatialReferenceFrame');
 ebsd = reduce(ebsd,2);

%% Global setting: Set the maximum SO3 bandwidth (to reduce truncation errors)
% setMTEXpref('maxSO3Bandwidth',92);

%% Calculate the ODF of the whole dataset and the (0002) pole figure intensity
ebsd_alpha = ebsd('Ti-Hex');
psi_all = calcKernel(ebsd_alpha.orientations);
odf_all = calcDensity(ebsd_alpha.orientations, 'kernel', psi_all);
h_0002 = Miller(0,0,0,2, ebsd_alpha.CS);

xDir = vector3d(1,0,0);
yDir = vector3d(0,1,0);
zDir = vector3d(0,0,1);

[value,ori_max] = max(odf_all);
euler_angles = Euler(ori_max); 
euler_angles_deg = euler_angles * (180/pi);
ebsd_max = ebsd_alpha.findByOrientation(ori_max,15*degree);
F_whole = numel(ebsd_max.orientations) / numel(ebsd_alpha.orientations);

PF_whole_X = calcPDF(odf_all, h_0002, xDir);
PF_whole_Y = calcPDF(odf_all, h_0002, yDir);
PF_whole_Z = calcPDF(odf_all, h_0002, zDir);
I_whole = norm(odf_all).^2;

fprintf('Whole map (0002) PF intensities:\n  X = %.5f\n  Y = %.5f\n  Z = %.5f\n',...
    PF_whole_X, PF_whole_Y, PF_whole_Z);
fprintf('Whole map texture index: %.5f\n', I_whole);
fprintf('Strongest texture component fraction: %.5f\n', F_whole);
fprintf('Strongest texture component Euler angles (deg): %.2f, %.2f, %.2f\n', euler_angles_deg(1), euler_angles_deg(2), euler_angles_deg(3));

%% Partition the EBSD map into strips (splitting along the X direction)
num_strips = 30; % Number of strips

% Define the size of the EBSD map (based on the gridify output)
ebsd_grid = ebsd.gridify;
ebsd_shape = size(ebsd_grid.id);
original_y = ebsd_shape(1);
original_x = ebsd_shape(2);
stepSize = ebsd_grid.dx;

% Calculate the dimensions in the x and y directions
x_min = 0;
x_max = original_x;
x_length = x_max - x_min;

y_min = 0;
y_max = original_y;
y_length = y_max - y_min;

% Determine the width of each strip in the X direction (in pixels, then multiplied by stepSize)
x_width = floor(x_length / num_strips);

% Create a Map to store the data for each strip
cutmap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

% Initialize a cell array to store the results for each strip.
% The first row is a header, the second row stores the whole map results;
% total number of rows = num_strips + 2.
results = cell(num_strips+2, 9);
results(1,:) = {'Region', 'PF_X', 'PF_Y', 'PF_Z','TextureIndex','Fraction','Euler1', 'Euler2', 'Euler3'};

results{2,1} = 'Whole Map';
results{2,2} = PF_whole_X;
results{2,3} = PF_whole_Y;
results{2,4} = PF_whole_Z;
results{2,5} = I_whole;
results{2,6} = F_whole;
results{2,7} = euler_angles_deg(1);
results{2,8} = euler_angles_deg(2);
results{2,9} = euler_angles_deg(3);

% Set a minimum threshold for the number of data points;
% if a strip has too few points, skip the ODF calculation.
minPoints = 50;

rowIdx = 3;  % Start writing strip results from row 3
for strip_index = 0:num_strips-1
    % Compute the starting X position of the current strip (in pixels)
    x_min_strip = strip_index * x_width;
    % Define the region: [lower-left x, lower-left y, width, height];
    % convert to actual lengths by multiplying by stepSize.
    region = [x_min_strip*stepSize, y_min*stepSize, x_width*stepSize, y_length*stepSize];
    
    % Extract EBSD data within the region
    condition = inpolygon(ebsd, region);
    ebsd_strip = ebsd(condition);
    cutmap(strip_index) = ebsd_strip;
    
    % Extract the Ti-Hex phase data for the current strip
    ebsd_strip_alpha = ebsd_strip('Ti-Hex');
    
    if isempty(ebsd_strip_alpha) || numel(ebsd_strip_alpha.orientations) < minPoints
        % If the current strip has too few data points, assign NaN and issue a warning
        warning('Strip %d has insufficient data points (%d), skipping ODF calculation.', strip_index+1, numel(ebsd_strip_alpha.orientations));
        PF_strip_X = NaN;
        PF_strip_Y = NaN;
        PF_strip_Z = NaN;
        I_strip = NaN;
        F_strip = NaN;
    else
        % Compute the kernel halfwidth and ODF for the current strip
        psi_strip = calcKernel(ebsd_strip_alpha.orientations);
        odf_strip = calcDensity(ebsd_strip_alpha.orientations, 'kernel', psi_strip,'calcODF','rbf');
        
        % Calculate the (0002) pole figure intensities in the X, Y, and Z directions for the current strip
        PF_strip_X = calcPDF(odf_strip, h_0002, xDir);
        PF_strip_Y = calcPDF(odf_strip, h_0002, yDir);
        PF_strip_Z = calcPDF(odf_strip, h_0002, zDir);
        I_strip = norm(odf_strip).^2;

        ebsd_strip_max = ebsd_strip_alpha.findByOrientation(ori_max, 15*degree);
        F_strip = numel(ebsd_strip_max.orientations) / numel(ebsd_strip_alpha.orientations); 

    end

    % Save the result for the current strip into the results cell array
    results{rowIdx,1} = sprintf('Strip %d', strip_index+1);
    results{rowIdx,2} = PF_strip_X;
    results{rowIdx,3} = PF_strip_Y;
    results{rowIdx,4} = PF_strip_Z;
    results{rowIdx,5} = I_strip;
    results{rowIdx,6} = F_strip;
    
    rowIdx = rowIdx + 1;
end

%% Write the results to a CSV file
% outputFilename = [sampleName, '_PF_ODF_fractions.csv'];
% writecell(results, outputFilename);
% fprintf('All (0002) PF intensity data have been saved to %s\n', outputFilename);
%%
% Define the folder path
folderPath = 'C:\Users\s79606xz\The University of Manchester Dropbox\Xiaohan Zeng\1-Nextwing\3-EBSD\2-result\fatigue life sample';

% Combine folder path with file name
outputFilename = fullfile(folderPath, [sampleName, '_PF_ODF_fractions.csv']);

% Write results to the CSV file
writecell(results, outputFilename);

% Print confirmation
fprintf('All (0002) PF intensity data have been saved to %s\n', outputFilename);

