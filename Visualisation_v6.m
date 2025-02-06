clc;
clear;
close all;

% Load data
data = xlsread('Ranking-equal-KER-HYD.xlsx');

% Extract relevant columns (columns 7 to 12)
relevant_data = data(:, 7:12);

% Extract column 1
column_1_data = data(:, 1);

% Define ranges
ranges = [
    1, 53111;
    53112, 106220;
];

% Initialize array to store the indices of the first occurrences
first_occurrence_indices = [];

% Loop through each range and find the first occurrence
for i = 1:size(ranges, 1)
    range_start = ranges(i, 1);
    range_end = ranges(i, 2);
    
    % Find the first value in column_1_data within the range
    idx = find(column_1_data >= range_start & column_1_data <= range_end, 1, 'first');
    
    if ~isempty(idx)
        first_occurrence_indices = [first_occurrence_indices; idx]; % Append index
    end
end

% Check if indices were found
if isempty(first_occurrence_indices)
    disp('No matching rows found for the given ranges.');
else
    % Extract the rows corresponding to the found indices
    filtered_data_all = data(first_occurrence_indices, :);
    filtered_data = relevant_data(first_occurrence_indices, :);

    % Write the filtered data to an Excel file
    writematrix(filtered_data, 'SI-firstpoints-ker-hyd-equal.xlsx');
    disp('Filtered data written to SI-firstpoints-ker-hyd.xlsx.');

    % Optional: Display the filtered data for verification
    disp('Filtered data:');
    disp(filtered_data_all);
end