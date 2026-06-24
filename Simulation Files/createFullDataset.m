% datasets folder
datasetFolder = "Datasets";

% get a list of all csv files (datasets) in the folder
csvFiles = dir(fullfile(datasetFolder, 'L*.csv'));

% initialize an empty table for the combined data
fullDataset = [];

% loop through each csv file and append its data to fullDataset
for k = 1:length(csvFiles)
    %Get the full path of the current csv file
    filePath = fullfile(datasetFolder, csvFiles(k).name);

    % read the current csv file into a table
    data = readtable(filePath);

    % append the data to the combined table
    fullDataset = [fullDataset; data];
end

% specify the output file path for the combined csv file
combinedDataPath = fullfile(datasetFolder, 'full_dataset.csv');

% finally, write the combined data to the new csv file
writetable(fullDataset, combinedDataPath);

% write a message to notify end of operation
disp('All csv files have been merged into full_dataset.csv');

% make 2 beep sounds to signify end of operation
beep
pause(2)
beep